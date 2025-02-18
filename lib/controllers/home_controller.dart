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
      await _firestoreService.getSocialLinks();
      
      final journals = await _firestoreService.getJournals();

      return renderHtml('home/index.html', {
        'title': 'My Journal',
        'journals': journals.map((j) => j.toJson()).toList(),
      });
    } catch (e) {
      print('Error fetching journals: $e');
      return renderHtml('home/index.html', {
        'title': 'My Journal',
        'error': 'Failed to load journals',
      });
    }
  }
}
