import 'package:dart_main_website/config/article_page.dart';
import 'package:shelf/shelf.dart';
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
    return Response.movedPermanently(article.pdf);
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
