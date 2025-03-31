import 'package:dart_main_website/config/layout.html.dart';
import 'package:shelf/shelf.dart';
import '../services/firestore_service.dart';
import '../server.dart';
import '../controllers/base_controller.dart';

class IssueController extends BaseController {
  final _firestoreService = FirestoreService();

  String _getMonthName(int month) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return monthNames[month - 1];
  }

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

      // Get Volume details
      final volume = await _firestoreService.getVolumeById(issue.volumeId);

      // Get articles for the issue
      final articles = await _firestoreService.getArticlesByIssue(issueId);

      String issueDate = '${_getMonthName(issue.fromDate.month)} ${issue.fromDate.year}';

      // Helper function to convert month number to name

      return renderHtml('dynamic-pages/articles-list.html', {
        'header': getHeaderHtml(journal),
        'footer': getFooterHtml(journal),
        'journal': journal.toJson(),
        'domain': domain,
        'issueDate': issueDate,
        'volume': volume?.toJson(),
        'volumeNo': volume?.volumeNumber,
        'issueNo': issue.issueNumber,
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
