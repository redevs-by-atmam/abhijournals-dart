import 'dart:developer';

import 'package:dart_main_website/models/article.dart';
import 'package:dart_main_website/models/journal.dart';
import 'package:dart_main_website/models/home_content_model.dart';
import 'package:firedart/firedart.dart';
import '../config/firebase_config.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  late Firestore _firestore;

  factory FirestoreService() {
    return _instance;
  }

  FirestoreService._internal() {
    Firestore.initialize(FirebaseConfig.projectId);
    _firestore = Firestore.instance;
  }

  Future<List<JournalModel>> getJournals() async {
    try {
      final snapshot = await _firestore.collection('journals').get();
      final journals =
          snapshot.map((doc) => JournalModel.fromJson(doc.map)).toList();
      return journals;
    } catch (e) {
      print('Error getting journals: $e');
      rethrow;
    }
  }

  Future<JournalModel?> getJournalByDomain(String domain) async {
    try {
      log('Getting journal by domain: $domain');
      
      // Skip favicon.ico requests
      if (domain == 'favicon.ico') {
        return null;
      }

      final snapshot = await _firestore
          .collection('journals')
          .where('domain', isEqualTo: domain)
          .get();

      if (snapshot.isEmpty) {
        log('No journal found for domain: $domain');
        return null;
      }

      final doc = snapshot.first;

      // Include the document ID in the data
      final data = {
        'id': doc.id,
        ...doc.map,
      };

      return JournalModel.fromJson(data);
    } catch (e) {
      log('Error getting journal by domain: $e');
      return null;
    }
  }

  Future<List<ArticleModel>> getArticlesByDomain(String domain) async {
    try {
      final snapshot = await _firestore
          .collection('journals')
          .document(domain)
          .collection('articles')
          .get();

      print(snapshot.map((doc) => doc.map).toList());

      return snapshot.map((doc) => ArticleModel.fromJson(doc.map)).toList();
    } catch (e) {
      print('Error getting articles: $e');
      rethrow;
    }
  }

  Future<HomeContentModel?> getHomeContent(JournalModel journal) async {
    try {
      log('Getting home content for journal: ${journal.id}');
      final snapshot = await _firestore
          .collection('home-pages')
          .document(journal.id)
          .get();

      if (snapshot.map.isEmpty) {
        log('No home content found for journal: ${journal.id}');
        return null;
      }


      return HomeContentModel.fromJson({
        'id': snapshot.id,
        ...snapshot.map,
      });
    } catch (e) {
      log('Error getting home content: $e');
      return null;
    }
  }
}
