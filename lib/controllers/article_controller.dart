import 'package:dart_main_website/config/article_page.dart';
import 'package:shelf/shelf.dart';
import 'package:dio/dio.dart' hide Response;
import '../services/firestore_service.dart';
import '../server.dart';

class ArticleController {
  final _firestoreService = FirestoreService();

  Future<Response> pdf(
      Request request, String domain, String articleId, String pdfTitle) async {
    final article = await _firestoreService.getArticleById(articleId);
    if (article == null) {
      return Response.notFound('Article not found');
    }

    // Option 1: redirect to the PDF URL
    // return Response.found(article.pdf);

    // Option 2: fetch and proxy the PDF content
    final dioResponse = await Dio().get<List<int>>(
      article.pdf,
      options: Options(responseType: ResponseType.bytes),
    );
    final pdfBytes = dioResponse.data;
    if (pdfBytes == null) {
      return Response.internalServerError(body: 'Failed to fetch PDF');
    }
    return Response.ok(
      pdfBytes,
      headers: {
        'Content-Type': 'application/pdf',
        'Content-Disposition': 'attachment; filename="$pdfTitle.pdf"',
      },
    );
  }

  Future<Response> show(
      Request request, String domain, String articleId) async {
    try {
      // Get journal first
      final journal = await _firestoreService.getJournalByDomain(domain);

      // Get article details
      final article = await _firestoreService.getArticleById(articleId);

      if (article == null) {
        return Response.notFound('Article not found');
      }

      // Get issue details
      final issue = await _firestoreService.getIssueById(article.issueId);

      // Get volume details
      final volume = await _firestoreService.getVolumeById(article.volumeId);

      return renderHtml('dynamic-pages/article-page.html',
          {'articlePage': articlePage(article, journal!, issue!, volume!)});
    } catch (e) {
      print('Error fetching article: $e');
      return Response.internalServerError(
          body: 'An error occurred while processing your request');
    }
  }
}
