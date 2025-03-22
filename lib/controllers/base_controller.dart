import '../services/cache_service.dart';
import '../services/firestore_service.dart';
import '../models/journal.dart';

class BaseController {
  final _firestoreService = FirestoreService();
  final _cacheService = CacheService();

  Future<JournalModel?> getJournal(String domain) async {
    // Try cache first
    final cachedJournal = _cacheService.getJournal(domain);
    if (cachedJournal != null) {
      return cachedJournal;
    }

    // If not in cache, fetch from Firestore
    return await _firestoreService.getJournalByDomain(domain);
  }
} 