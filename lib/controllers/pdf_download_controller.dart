import 'dart:typed_data';

import 'package:dart_main_website/env/env.dart';
import 'package:dart_main_website/services/firestore_service.dart';
import 'package:dio/dio.dart' as dio;
import 'package:shelf/shelf.dart';

final _dio = dio.Dio();
final _firestoreService = FirestoreService();

class PdfDownloadController {
  static const String ilovePdfPublicKey = Env.ilovepdfPublicKey;
  static const String ilovePdfSecretKey = Env.ilovepdfSecretKey;
  static const String ilovePdfApiBase = 'https://api.ilovepdf.com/v1';

  Future<Response> downloadPdf(Request request) async {
    // Extract domain and issueId from the URL path
    final pathSegments = request.url.pathSegments;
    final domain = pathSegments.isNotEmpty ? pathSegments.first : 'unknown';

    // Find the issueId after '/issue/'
    String issueId = 'unknown';
    for (int i = 0; i < pathSegments.length - 1; i++) {
      if (pathSegments[i] == 'issue') {
        issueId = pathSegments[i + 1];
        break;
      }
    }

    if (issueId == 'unknown') {
      return _errorHtml(
        domain,
        issueId,
        'Could not determine issueId from the URL. Please check the request path.',
        [],
      );
    }

    // Fetch articles for the given issueId
    List<String> pdfUrls = [];
    try {
      final articles = await _firestoreService.getArticlesByIssue(issueId);
      if (articles.isEmpty) {
        return _errorHtml(
          domain,
          issueId,
          'No articles found for this issue. Cannot merge PDFs.',
          [],
        );
      }
      // Collect all non-empty PDF URLs from the articles
      pdfUrls = articles
          .map((article) => article.pdf.trim())
          .where((url) => url.isNotEmpty)
          .toList();

      if (pdfUrls.isEmpty) {
        return _errorHtml(
          domain,
          issueId,
          'No valid PDF URLs found for the articles in this issue.',
          [],
        );
      }
    } catch (e) {
      return _errorHtml(
        domain,
        issueId,
        'Failed to fetch articles for this issue: $e',
        [],
      );
    }

    try {
      // 1. Get ILovePDF auth token
      final authResp = await _dio.post(
        '$ilovePdfApiBase/auth',
        data: {'public_key': ilovePdfPublicKey},
      );
      if (authResp.statusCode != 200 || authResp.data['token'] == null) {
        return _errorHtml(
            domain,
            issueId,
            'Failed to authenticate with ILovePDF. Please check your API keys and try again.',
            pdfUrls);
      }
      final ilovePdfToken = authResp.data['token'];

      // 2. Start a merge task
      final taskResp = await _dio.post(
        '$ilovePdfApiBase/start/merge',
        options:
            dio.Options(headers: {'Authorization': 'Bearer $ilovePdfToken'}),
      );
      if (taskResp.statusCode != 200 || taskResp.data['task'] == null) {
        return _errorHtml(
            domain,
            issueId,
            'Failed to start ILovePDF merge task. Please try again later.',
            pdfUrls);
      }
      final taskId = taskResp.data['task'];

      // 3. Add files by URL
      for (final url in pdfUrls) {
        final addResp = await _dio.post(
          '$ilovePdfApiBase/upload/url',
          data: {
            'task': taskId,
            'cloud_file': url,
          },
          options:
              dio.Options(headers: {'Authorization': 'Bearer $ilovePdfToken'}),
        );
        if (addResp.statusCode != 200) {
          return _errorHtml(
              domain,
              issueId,
              'Failed to add PDF from URL: $url. Please ensure the URL is correct and accessible.',
              pdfUrls);
        }
      }

      // 4. Process the merge
      final processResp = await _dio.post(
        '$ilovePdfApiBase/process',
        data: {
          'task': taskId,
        },
        options:
            dio.Options(headers: {'Authorization': 'Bearer $ilovePdfToken'}),
      );
      if (processResp.statusCode != 200) {
        return _errorHtml(
            domain,
            issueId,
            'Failed to process PDF merge. Please try again.',
            pdfUrls);
      }

      // 5. Download the merged PDF
      final downloadResp = await _dio.get<List<int>>(
        '$ilovePdfApiBase/download/$taskId',
        options: dio.Options(
          headers: {'Authorization': 'Bearer $ilovePdfToken'},
          responseType: dio.ResponseType.bytes,
        ),
      );
      if (downloadResp.statusCode != 200 || downloadResp.data == null) {
        return _errorHtml(
            domain,
            issueId,
            'Failed to download merged PDF. Please try again.',
            pdfUrls);
      }

      final mergedBytes = Uint8List.fromList(downloadResp.data!);

      return Response.ok(
        mergedBytes,
        headers: {
          'Content-Type': 'application/pdf',
          'Content-Disposition': 'attachment; filename=issue_$issueId.pdf',
          'X-Complete-Url':
              '/$domain/issue/$issueId/articles/download/?complete=true',
        },
      );
    } catch (e) {
      // Print the error to the console for debugging
      print('Error while downloading or merging PDFs: $e');
      // If it's a DioException, print more details
      if (e is dio.DioException) {
        print('DioException details:');
        print('Type: ${e.type}');
        print('Message: ${e.message}');
        print('Response: ${e.response}');
        print('RequestOptions: ${e.requestOptions}');
      }
      return _errorHtml(
        domain,
        issueId,
        "Due to a technical glitch, the issue PDF can't be downloaded or merged at this time. However, you can view the individual article PDFs using the links below.",
        pdfUrls,
      );
    }
  }

  Response _errorHtml(String domain, String issueId, String message, List<String> pdfUrls) {
    final pdfLinksHtml = pdfUrls.isNotEmpty
        ? '''
  <h2>Article PDFs</h2>
  <ul>
    ${pdfUrls.map((url) => '<li><a href="$url" target="_blank">$url</a></li>').join('\n    ')}
  </ul>
  '''
        : '';

    final html = '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>PDF Download Failed</title>
</head>
<body>
  <h1>PDF Merge Error</h1>
  <p style="color: red;">$message</p>
  $pdfLinksHtml
  <a href="/$domain/issue/$issueId/articles/download/?complete=true">Try again</a>
</body>
</html>
''';

    return Response.internalServerError(
      body: html,
      headers: {'Content-Type': 'text/html'},
    );
  }
}
