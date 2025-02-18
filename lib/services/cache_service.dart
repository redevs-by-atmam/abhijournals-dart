import 'dart:async';
import '../models/journal.dart';

class CacheService {
  static final CacheService _instance = CacheService._internal();
  
  // Cache for journals with domain as key
  final Map<String, JournalModel> _journalCache = {};
  
  // Timer for cleanup
  Timer? _cleanupTimer;
  
  // Cache duration (5 minutes)
  static const cacheDuration = Duration(minutes: 5);
  
  factory CacheService() {
    return _instance;
  }
  
  CacheService._internal();
  
  JournalModel? getJournal(String domain) {
    return _journalCache[domain];
  }
  
  void setJournal(String domain, JournalModel journal) {
    _journalCache[domain] = journal;
    _resetCleanupTimer();
  }
  
  void _resetCleanupTimer() {
    _cleanupTimer?.cancel();
    _cleanupTimer = Timer(cacheDuration, () {
      clearCache();
    });
  }
  
  void clearCache() {
    _journalCache.clear();
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
  }
  
  bool hasJournal(String domain) {
    return _journalCache.containsKey(domain);
  }
} 