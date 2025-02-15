import 'package:dart_main_website/config/layout.html.dart';
import 'package:shelf/shelf.dart';
import '../services/firestore_service.dart';
import '../server.dart';

class ArchiveController {
  final _firestoreService = FirestoreService();

  Future<Response> index(Request request, String domain) async {
    try {
      // Get journal
      final journal = await _firestoreService.getJournalByDomain(domain);
      
      // Get all volumes for this journal
      final volumes = await _firestoreService.getVolumesByJournalId(journal!.id);

      return renderHtml('dynamic-pages/archives.html', {
        'header': getHeaderHtml(journal),
        'footer': getFooterHtml(journal),
        'journal': journal.toJson(),
        'domain': journal.domain,
        'volumes': volumes.map((vol) => vol.toJson()).toList(),
        'hasVolumes': volumes.isNotEmpty,
      });
    } catch (e) {
      print('Error fetching archives: $e');
      return Response.internalServerError(
        body: 'An error occurred while processing your request'
      );
    }
  }

  Future<Response> showVolumeIssues(Request request, String domain, String volumeId) async {
    try {
      // Get journal
      final journal = await _firestoreService.getJournalByDomain(domain);
      
      // Get volume details
      final volume = await _firestoreService.getVolumeById(volumeId);
      
      // Get all issues for this volume
      final issues = await _firestoreService.getIssuesByVolumeId(volumeId);

      return renderHtml('dynamic-pages/volume-issues.html', {
        'header': getHeaderHtml(journal!),
        'footer': getFooterHtml(journal),
        'journal': journal.toJson(),
        'domain': journal.domain,
        'volume': volume?.toJson(),
        'issues': issues.map((issue) => issue.toJson()).toList(),
        'hasIssues': issues.isNotEmpty,
      });
    } catch (e) {
      print('Error fetching volume issues: $e');
      return Response.internalServerError(
        body: 'An error occurred while processing your request'
      );
    }
  }
} 