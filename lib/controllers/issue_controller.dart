import 'package:dart_main_website/config/layout.html.dart';
import 'package:shelf/shelf.dart';
import '../services/firestore_service.dart';
import '../server.dart';
import '../controllers/base_controller.dart';

class IssueController extends BaseController {
  final _firestoreService = FirestoreService();

  Future<Response> getArticles(
      Request request, String domain, String issueId) async {
    try {
      // Get journal using cached version if available
      final journal = await getJournal(domain);
      if (journal == null) {
        return renderNotFound(
            {'domain': domain, 'message': 'Journal not found'});
      }

      // Get issue details first
      final issue = await _firestoreService.getIssueById(issueId);
      if (issue == null) {
        return renderNotFound({'domain': domain, 'message': 'Issue not found'});
      }

      // Get articles for the issue
      final articles = await _firestoreService.getArticlesByIssue(issueId);

      return renderHtml('dynamic-pages/articles-list.html', {
        'header': getHeaderHtml(journal),
        'footer': getFooterHtml(journal),
        'journal': journal.toJson(),
        'domain': domain,
        'issue': issue.toJson(),
        'issueId': issueId,
        'articles': articles.map((article) => article.toJson()).toList(),
        'hasArticles': articles.isNotEmpty,
      });
    } catch (e) {
      print('Error fetching articles: $e');
      return renderError(
          'An error occurred while fetching the articles', {'domain': domain});
    }
  }
}
