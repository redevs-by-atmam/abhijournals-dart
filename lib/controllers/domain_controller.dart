import 'package:dart_main_website/config/layout.html.dart';
import 'package:dart_main_website/models/home_content_model.dart';
import 'package:dart_main_website/models/journal.dart';
import 'package:dart_main_website/server.dart';
import 'package:shelf/shelf.dart';
import '../services/firestore_service.dart';

class AllDataModel {
  final JournalModel journal;
  final HomeContentModel homeContent;

  AllDataModel({required this.journal, required this.homeContent});
}

class DomainController {
  final _firestoreService = FirestoreService();

  Future<Response> index(Request request, String domain) async {
    try {
      // Skip favicon.ico requests
      if (domain == 'favicon.ico') {
        return Response.notFound('Not found');
      }

      // Get journal by domain
      final journal = await _firestoreService.getJournalByDomain(domain);

      if (journal == null) {
        return Response.notFound('Journal not found');
      }

      final homeContent = await _firestoreService.getHomeContent(journal);

      return renderHtml('index.html', {
        'journal': journal.toJson(),
        'header': getHeaderHtml(journal),
        'footer': getFooterHtml(journal),
        'content': homeContent?.toJson()
      });
    } catch (e) {
      print('Error in domain controller: $e');
      return Response.internalServerError(
          body: 'An error occurred while processing your request');
    }
  }

  Future<Response> show(Request request, String domain) async {
    try {
      final journal = await _firestoreService.getJournalByDomain(domain);

      if (journal == null) {
        return Response.notFound('Journal not found');
      }

      return Response.ok('Journal: ${journal.title}\nDomain: $domain',
          headers: {'content-type': 'text/plain'});
    } catch (e) {
      print('Error fetching journal: $e');
      return Response.internalServerError(body: 'Internal Server Error');
    }
  }
}
