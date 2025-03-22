import 'package:shelf/shelf.dart';
import '../services/firestore_service.dart';
import '../server.dart';

class HomeController {
  final _firestoreService = FirestoreService();

  Future<Response> index(Request request) async {
    try {
      // Preload social links on homepage visit
      final socialLinks = await _firestoreService.getSocialLinks();

      final journals = await _firestoreService.getJournals();

      // Fetch homepage template and content from Firebase
      final content =
          await _firestoreService.getConfigDocument('main-home');

      final homeCounts = await _firestoreService.getHomeCounts();

      // Create the template variables
      final templateVars = {
        'homeCounts': homeCounts.toJson(),
        'shortTitle': content['shortTitle'] ?? 'Abhi',
        'shortForm': content['shortForm'] ?? 'AIJ',
        'logoUrl': content['logoUrl'] ?? '',
        'faviconUrl': content['faviconUrl'] ?? '',
        'adminUrl': content['adminUrl'] ?? 'https://admin.abhijournals.com',
        'fullTitle': content['fullTitle'] ?? 'Abhi International Journals',
        'description': content['description'] ?? '',
        'keywords': content['keywords'] ?? '',
        'journals': journals.map((j) => j.toJson()).toList(),
        'hero': content['hero']?.toString() ?? '',
        'about': content['about']?.toString() ?? '',
        'header': content['header']?.toString() ?? '',
        'footer': content['footer']?.toString() ?? '',
        'features': content['features']?.toString() ?? '',
        'whyPublish': content['why']?.toString() ?? '',
        'contact': content['contact']?.toString() ?? '',
        'socialLinks':
            socialLinks.map((key, value) => MapEntry(key, value.toJson())),
      };

      // Render the HTML template
      final renderedHtml = await renderHtml('home/index.html', templateVars);

      return Response.ok(
        renderedHtml.read(),
        headers: {'content-type': 'text/html'},
      );
    } catch (e) {
      print('Error loading homepage: $e');
      // Render error page
      return Response.notFound('Error loading homepage');
    }
  }
}
