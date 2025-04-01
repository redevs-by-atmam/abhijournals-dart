import 'package:dart_main_website/services/firestore_service.dart';
import 'package:dio/dio.dart' as dio;
import 'dart:developer' as developer;
import 'package:shelf/shelf.dart';
import 'dart:typed_data';

class PdfDownloadController {
  final dio.Dio _dio = dio.Dio();
  final String supabaseEndpoint =
      'https://etvzvjlkhdcmurvsqaao.supabase.co/functions/v1/merge-pdf-ilovepdf';

  /// Main method to download and merge PDFs
  Future<Response> downloadPdf(
      Request request, String domain, String issueId) async {
    developer.log(
        'Starting PDF download and merge process for issue: $issueId, domain: $domain');

    // Check if this is the initial request or the actual download request
    final isDownloadRequest = request.url.queryParameters['download'] == 'true';
    final isComplete = request.url.queryParameters['complete'] == 'true';

    if (isComplete) {
      // Show download complete page
      return Response.ok(
        '''
        <!DOCTYPE html>
        <html>
        <head>
          <title>Download Complete</title>
          <style>
            body {
              font-family: Arial, sans-serif;
              text-align: center;
              margin-top: 100px;
            }
            .success-icon {
              color: green;
              font-size: 80px;
              margin-bottom: 20px;
            }
            h2 {
              color: #033e93;
            }
            .btn {
              background-color: #033e93;
              color: white;
              padding: 10px 20px;
              text-decoration: none;
              border-radius: 5px;
              display: inline-block;
              margin-top: 20px;
            }
          </style>
        </head>
        <body>
          <div class="success-icon">✓</div>
          <h2>पीडीएफ डाउनलोड हो गया है!</h2>
          <h2>PDF has been downloaded successfully!</h2>
          <p>Your file has been downloaded to your device.</p>
          <a href="/$domain/issue/$issueId/articles/" class="btn">Return to Issue</a>
        </body>
        </html>
        ''',
        headers: {'Content-Type': 'text/html'},
      );
    }

    if (!isDownloadRequest) {
      // Show loading page to inform user that PDFs are being merged
      return Response.ok(
        '''
        <!DOCTYPE html>
        <html>
        <head>
          <title>Merging PDFs</title>
          <style>
            body {
              font-family: Arial, sans-serif;
              text-align: center;
              margin-top: 100px;
            }
            .loader {
              border: 16px solid #f3f3f3;
              border-radius: 50%;
              border-top: 16px solid #033e93;
              width: 120px;
              height: 120px;
              animation: spin 2s linear infinite;
              margin: 0 auto;
              margin-bottom: 30px;
            }
            @keyframes spin {
              0% { transform: rotate(0deg); }
              100% { transform: rotate(360deg); }
            }
            h2 {
              color: #033e93;
            }
            #error {
              color: red;
              display: none;
            }
          </style>
          <script>
            window.onload = function() {
              setTimeout(function() {
                // Add download parameter to indicate this is the actual download request
                window.location.href = window.location.href + (window.location.href.includes('?') ? '&' : '?') + 'download=true';
              }, 2000); // Wait 2 seconds before redirecting to show the loading message
            };
          </script>
        </head>
        <body>
          <div class="loader"></div>
          <h2>मर्जिंग पीडीएफ, कृपया प्रतीक्षा करें...</h2>
          <h2>Merging PDFs, please wait...</h2>
          <p>Your download will start automatically once the PDFs are merged.</p>
          <p id="error">Error occurred during PDF merging. Please try again later.</p>
        </body>
        </html>
        ''',
        headers: {'Content-Type': 'text/html'},
      );
    }

    try {
      // Fetch articles and extract PDF URLs
      final articles = await FirestoreService().getArticlesByIssue(issueId);

      if (articles.isEmpty) {
        return Response.notFound('No articles found for this issue');
      }

      final pdfUrls = articles
          .map((article) => article.pdf)
          .where((url) => url.isNotEmpty)
          .toList();

      if (pdfUrls.isEmpty) {
        return Response.notFound(
            'No PDF files found for articles in this issue');
      }

      // Call the PDF merge service
      final response = await _dio.post(
        supabaseEndpoint,
        data: {'urls': pdfUrls},
        options: dio.Options(
          receiveTimeout: const Duration(minutes: 2),
          sendTimeout: const Duration(minutes: 2),
        ),
      );

      // Extract the download URL from the response
      if (response.data['success'] == true &&
          response.data['downloadUrl'] != null) {
        // If downloadUrl is a Buffer object
        if (response.data['downloadUrl'] is Map &&
            response.data['downloadUrl']['type'] == 'Buffer' &&
            response.data['downloadUrl']['data'] is List) {
          // Convert the buffer data to Uint8List
          final List<int> bufferData =
              List<int>.from(response.data['downloadUrl']['data']);
          final Uint8List pdfBytes = Uint8List.fromList(bufferData);

          // Return the PDF data directly with a script to redirect to the completion page
          return Response.ok(
            pdfBytes,
            headers: {
              'Content-Type': 'application/pdf',
              'Content-Disposition':
                  'attachment; filename=issue_$issueId.pdf',
              'X-Complete-Url':
                  '/$domain/issue/$issueId/articles/download/?complete=true',
            },
          );
        } else if (response.data['downloadUrl'] is String) {
          // If downloadUrl is a string URL, fetch the PDF content
          final pdfResponse = await _dio.get(
            response.data['downloadUrl'],
            options: dio.Options(responseType: dio.ResponseType.bytes),
          );

          // Return the PDF data with a script to redirect to the completion page
          return Response.ok(
            pdfResponse.data,
            headers: {
              'Content-Type': 'application/pdf',
              'Content-Disposition':
                  'attachment; filename=issue_$issueId.pdf',
              'X-Complete-Url':
                  '/$domain/issue/$issueId/articles/download/?complete=true',
            },
          );
        }
      }

      // If we get here, something went wrong with the response format
      developer.log('Invalid response format: ${response.data}');
      return Response.internalServerError(
        body: '''
        <!DOCTYPE html>
        <html>
        <head>
          <title>Error</title>
          <style>
            body {
              font-family: Arial, sans-serif;
              text-align: center;
              margin-top: 100px;
            }
            .error-icon {
              color: red;
              font-size: 80px;
              margin-bottom: 20px;
            }
            h2 {
              color: #033e93;
            }
            .btn {
              background-color: #033e93;
              color: white;
              padding: 10px 20px;
              text-decoration: none;
              border-radius: 5px;
              display: inline-block;
              margin-top: 20px;
            }
          </style>
        </head>
        <body>
          <div class="error-icon">✗</div>
          <h2>Network response was not ok</h2>
          <p>Failed to process PDF merge: Invalid response format</p>
          <a href="/$domain/issue/$issueId/articles/" class="btn">Return to Issue</a>
        </body>
        </html>
        ''',
        headers: {'Content-Type': 'text/html'},
      );
    } catch (e) {
      developer.log('Error during PDF merge: $e');
      return Response.internalServerError(
        body: '''
        <!DOCTYPE html>
        <html>
        <head>
          <title>Error</title>
          <style>
            body {
              font-family: Arial, sans-serif;
              text-align: center;
              margin-top: 100px;
            }
            .error-icon {
              color: red;
              font-size: 80px;
              margin-bottom: 20px;
            }
            h2 {
              color: #033e93;
            }
            .btn {
              background-color: #033e93;
              color: white;
              padding: 10px 20px;
              text-decoration: none;
              border-radius: 5px;
              display: inline-block;
              margin-top: 20px;
            }
          </style>
        </head>
        <body>
          <div class="error-icon">✗</div>
          <h2>Network response was not ok</h2>
          <p>Failed to process PDF merge: ${e.toString()}</p>
          <a href="/$domain/issue/$issueId/articles/" class="btn">Return to Issue</a>
        </body>
        </html>
        ''',
        headers: {'Content-Type': 'text/html'},
      );
    }
  }
}
