import 'package:dart_main_website/config/layout.html.dart';
import 'package:shelf/shelf.dart';
import '../services/firestore_service.dart';
import '../server.dart';

class IssueController {
  final _firestoreService = FirestoreService();

  Future<Response> getArticles(
      Request request, String domain, String issueId) async {
    try {
      // Get journal first
      final journal = await _firestoreService.getJournalByDomain(domain);

      // Get articles for the issue
      final articles =
          await _firestoreService.getArticlesByIssue( issueId);

      // Get issue details
      final issue = await _firestoreService.getIssueById(issueId);

      return renderHtml('dynamic-pages/articles-list.html', {
        'header': getHeaderHtml(journal!),
        'footer': getFooterHtml(journal),
        'journal': journal.toJson(),
        'domain': journal.domain,
        'hasArticles': articles.isNotEmpty,
        'issue': issue!.toJson(),
        'articles': articles.map((article) => article.toJson()).toList(),
      });
    } catch (e) {
      print('Error fetching articles: $e');
      return Response.internalServerError(
          body: 'An error occurred while processing your request');
    }
  }
}
