import 'package:dart_main_website/config/layout.html.dart';
import 'package:dart_main_website/models/journal.dart';
import 'package:shelf/shelf.dart';
import '../services/firestore_service.dart';
import '../server.dart';
import '../env/env.dart';

class HomeController {
  final _firestoreService = FirestoreService();

  Future<Response> index(Request request) async {
    try {
      // Preload social links on homepage visit
      final socialLinks = await _firestoreService.getSocialLinks();

      final journals = await _firestoreService.getJournals();

      // Fetch homepage template and content from Firebase
      final homepageConfig =
          await _firestoreService.getConfigDocument('main-home');
      final content = homepageConfig;

      // Create the template variables
      final templateVars = {
        'title': content['title'] ?? 'Abhi International Journals',
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
