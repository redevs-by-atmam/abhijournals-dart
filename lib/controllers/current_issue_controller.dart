import 'package:dart_main_website/config/layout.html.dart';
import 'package:shelf/shelf.dart';
import '../services/firestore_service.dart';
import '../server.dart';

class CurrentIssueController {
  final _firestoreService = FirestoreService();

  Future<Response> index(Request request, String domain) async {
    try {
      // Get journal
      final journal = await _firestoreService.getJournalByDomain(domain);

      final latestIssue = await _firestoreService.getLatestIssue();
      final latestVolume = await _firestoreService.getLatestVolume();

      // Get articles for latest issue
      final articles =
          await _firestoreService.getArticlesByIssue(latestIssue.id);

      print('Articles: ${articles.length}');

      return renderHtml('dynamic-pages/articles-list.html', {
        'header': getHeaderHtml(journal!),
        'footer': getFooterHtml(journal),
        'journal': journal.toJson(),
        'domain': journal.domain,
        'issue': latestIssue.toJson(),
        'volume': latestVolume.toJson(),
        'articles': articles.map((article) => article.toJson()).toList(),
        'hasArticles': articles.isNotEmpty,
      });
    } catch (e) {
      print('Error fetching current issue: $e');
      return Response.internalServerError(
          body: 'An error occurred while processing your request');
    }
  }

  Future<Response> byIssue(Request request, String domain) async {
    try {
      // Get journal
      final journal = await _firestoreService.getJournalByDomain(domain);

      // Get latest volume
      final latestVolume = await _firestoreService.getLatestVolume();

      // Get all issues for latest volume
      final issues =
          await _firestoreService.getIssuesByVolumeId(latestVolume.id);

      return renderHtml('dynamic-pages/volume-issues.html', {
        'header': getHeaderHtml(journal!),
        'footer': getFooterHtml(journal),
        'journal': journal.toJson(),
        'domain': journal.domain,
        'volume': latestVolume.toJson(),
        'issues': issues.map((issue) => issue.toJson()).toList(),
        'hasIssues': issues.isNotEmpty,
      });
    } catch (e) {
      print('Error fetching issues: $e');
      return Response.internalServerError(
          body: 'An error occurred while processing your request');
    }
  }
}
