import 'package:dart_main_website/models/journal.dart';
import 'package:shelf/shelf.dart';
import '../services/firestore_service.dart';
import '../server.dart';
import '../env/env.dart';

class HomeController {
  final _firestoreService = FirestoreService();

  Future<Response> index(Request request) async {
    try {
      final List<JournalModel> journals = await _firestoreService.getJournals();
      print(journals);

      return renderHtml('home/index.html', {
        'title': 'My Journal',
        'journals': journals.map((journal) => journal.toJson()).toList(),
        'hasJournals': journals.isNotEmpty,
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
