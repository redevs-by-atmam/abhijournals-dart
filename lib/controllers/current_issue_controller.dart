import 'package:dart_main_website/config/layout.html.dart';
import 'package:intl/intl.dart';
import 'package:shelf/shelf.dart';
import '../services/firestore_service.dart';
import '../server.dart';

class CurrentIssueController {
  final _firestoreService = FirestoreService();

  Future<Response> index(Request request, String domain) async {
    try {
      // Get journal
      final journal = await _firestoreService.getJournalByDomain(domain);
      if (journal == null) {
        return renderNotFound(
            {'domain': domain, 'message': 'Journal not found'});
      }

      // Get latest volume and issue for this specific journal
      final latestVolume =
          await _firestoreService.getLatestVolumeByJournalId(journal.id);
      if (latestVolume == null) {
        return renderError(
            'No volumes found for this journal', {'domain': domain});
      }

      final latestIssue =
          await _firestoreService.getLatestIssueByVolumeId(latestVolume.id);
      if (latestIssue == null) {
        return renderError(
            'No issues found for the latest volume', {'domain': domain});
      }

      // Get articles for latest issue
      final articles =
          await _firestoreService.getArticlesByIssue(latestIssue.id);

      print('Latest Volume: ${latestVolume.volumeNumber}');
      print('Latest Issue: ${latestIssue.issueNumber}');
      print('Articles found: ${articles.length}');

      final fromDate = DateFormat('MMMM - yyyy').format(latestIssue.fromDate);

      return renderHtml('dynamic-pages/current-issue.html', {
        'header': getHeaderHtml(journal),
        'footer': getFooterHtml(journal),
        'journal': journal.toJson(),
        'domain': journal.domain,
        'issueId': latestIssue.id,
        'issue': latestIssue.toJson(),
        'issueDate': fromDate,
        'volume': latestVolume.toJson(),
        'articles': articles.map((article) => article.toJson()).toList(),
        'hasArticles': articles.isNotEmpty,
      });
    } catch (e) {
      print('Error fetching current issue: $e');
      return renderError('An error occurred while fetching the current issue',
          {'domain': domain});
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
