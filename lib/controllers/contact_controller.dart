import 'package:dart_main_website/config/layout.html.dart';
import 'package:shelf/shelf.dart';
import '../services/firestore_service.dart';
import '../server.dart';
import '../controllers/base_controller.dart';

class ContactController extends BaseController {
  final _firestoreService = FirestoreService();

  Future<Response> index(Request request, String domain) async {
    try {
      final journal = await getJournal(domain);
      if (journal == null) {
        return Response.notFound('Journal not found');
      }

      final pageContent = await _firestoreService.getPageByDomain(journal.id, 'contact');

      return renderHtml('dynamic-pages/contact.html', {
        'header': getHeaderHtml(journal),
        'footer': getFooterHtml(journal),
        'journal': journal.toJson(),
        'domain': journal.domain,
        'pageModel': pageContent?.toJson(),
      });
    } catch (e) {
      print('Error fetching contact page: $e');
      return Response.internalServerError(
          body: 'An error occurred while processing your request');
    }
  }
} 