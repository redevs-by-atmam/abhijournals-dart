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

    // Fetch articles and extract PDF URLs as in your existing code
    final articles = await FirestoreService().getArticlesByIssue(issueId);
    final pdfUrls = articles.map((article) => article.pdf).toList();
    final response = await _dio.post(supabaseEndpoint, data: {
      'urls': pdfUrls,
    });

    // Extract the download URL from the response
    if (response.data['success'] == true && response.data['downloadUrl'] != null) {
      // If downloadUrl is a Buffer object
      if (response.data['downloadUrl'] is Map && 
          response.data['downloadUrl']['type'] == 'Buffer' && 
          response.data['downloadUrl']['data'] is List) {
        
        // Convert the buffer data to Uint8List
        final List<int> bufferData = List<int>.from(response.data['downloadUrl']['data']);
        final Uint8List pdfBytes = Uint8List.fromList(bufferData);
        
        // Return the PDF data directly
        return Response.ok(pdfBytes, headers: {
          'Content-Type': 'application/pdf',
          'Content-Disposition': 'attachment; filename=merged.pdf',
        });
      } else if (response.data['downloadUrl'] is String) {
        // If downloadUrl is a string URL, fetch the PDF content
        final pdfResponse = await _dio.get(
          response.data['downloadUrl'],
          options: dio.Options(responseType: dio.ResponseType.bytes),
        );
        
        return Response.ok(pdfResponse.data, headers: {
          'Content-Type': 'application/pdf',
          'Content-Disposition': 'attachment; filename=merged.pdf',
        });
      }
    }

    // Fallback if we couldn't get the PDF
    return Response.internalServerError(
      body: 'Failed to process PDF merge',
    );
  }
}
