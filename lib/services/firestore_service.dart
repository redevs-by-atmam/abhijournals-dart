import 'dart:developer';

import 'package:dart_main_website/models/article.dart';
import 'package:dart_main_website/models/issue.dart';
import 'package:dart_main_website/models/journal.dart';
import 'package:dart_main_website/models/home_content_model.dart';
import 'package:dart_main_website/models/page_model.dart';
import 'package:dart_main_website/models/volume.dart';
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

  Future<PageModel?> getPageByDomain(String journalId, String pageRoute) async {
    try {
      final snapshot = await _firestore
          .collection('pages')
          .where('journalId', isEqualTo: journalId)
          .where('url', isEqualTo: pageRoute)
          .get();

      return PageModel.fromJson(snapshot.first.map);
    } catch (e) {
      log('Error getting page by domain: $e');
      return null;
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

  Future<List<VolumeModel>> getVolumesByJournalId(String journalId) async {
    try {
      final snapshot = await _firestore
          .collection('volumes')
          .where('journalId', isEqualTo: journalId)
          .get();

      return snapshot.map((doc) => VolumeModel.fromJson(doc.map)).toList();
    } catch (e) {
      log('Error getting volumes by journal id: $e');
      return [];
    }
  }

  Future<List<IssueModel>> getIssuesByJournalId(String journalId) async {
    try {
      final snapshot = await _firestore
          .collection('issues')
          .where('journalId', isEqualTo: journalId)
          .get();

      return snapshot.map((doc) => IssueModel.fromJson(doc.map)).toList();
    } catch (e) {
      log('Error getting issues by journal id: $e');
      return [];
    }
  }

  Future<List<ArticleModel>> getArticlesByDomain(String domain) async {
    try {
      final snapshot = await _firestore
          .collection('articles')
          .where('journalId', isEqualTo: domain)
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
      final snapshot =
          await _firestore.collection('home-pages').document(journal.id).get();

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

  Future<List<ArticleModel>> getArticlesByIssue(String issueId) async {
    try {
      final snapshot = await _firestore
          .collection('articles')
          .where('issueId', isEqualTo: issueId)
          .get();

      return snapshot
          .map((doc) => ArticleModel.fromJson({
                'id': doc.id,
                ...doc.map,
              }))
          .toList();
    } catch (e) {
      log('Error getting articles by issue: $e');
      return [];
    }
  }

  Future<IssueModel?> getIssueById(String issueId) async {
    try {
      final doc = await _firestore.collection('issues').document(issueId).get();

      return IssueModel.fromJson({
        'id': doc.id,
        ...doc.map,
      });
    } catch (e) {
      log('Error getting issue: $e');
      return null;
    }
  }

  Future<ArticleModel?> getArticleById(String articleId) async {
    try {
      final doc =
          await _firestore.collection('articles').document(articleId).get();

      return ArticleModel.fromJson({
        'id': doc.id,
        ...doc.map,
      });
    } catch (e) {
      log('Error getting article: $e');
      return null;
    }
  }

  Future<VolumeModel?> getVolumeById(String volumeId) async {
    try {
      final doc =
          await _firestore.collection('volumes').document(volumeId).get();

      return VolumeModel.fromJson({
        'id': doc.id,
        ...doc.map,
      });
    } catch (e) {
      log('Error getting volume: $e');
      return null;
    }
  }

  Future<List<IssueModel>> getIssuesByVolumeId(String volumeId) async {
    try {
      final snapshot = await _firestore
          .collection('issues')
          .where('volumeId', isEqualTo: volumeId)
          .orderBy('issueNumber')
          .get();

      return snapshot
          .map((doc) => IssueModel.fromJson({
                'id': doc.id,
                ...doc.map,
              }))
          .toList();
    } catch (e) {
      log('Error getting issues by volume: $e');
      return [];
    }
  }

  Future<List<ArticleModel>> getArticlesByVolumeAndIssue(
      String volumeId, String issueId) async {
    try {
      final snapshot = await _firestore
          .collection('articles')
          .where('volumeId', isEqualTo: volumeId)
          .where('issueId', isEqualTo: issueId)
          .get();

      return snapshot
          .map((doc) => ArticleModel.fromJson({
                'id': doc.id,
                ...doc.map,
              }))
          .toList();
    } catch (e) {
      log('Error getting articles by volume and issue: $e');
      return [];
    }
  }

  // function to get latest volume and issues
  Future<VolumeModel> getLatestVolume() async {
    try {
      final snapshot = await _firestore
          .collection('volumes')
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      final volume = VolumeModel.fromJson(snapshot.first.map);

      return volume;
    } catch (e) {
      log('Error getting latest volume and issues: $e');
      rethrow;
    }
  }

  Future<IssueModel> getLatestIssue() async {
    try {
      final snapshot = await _firestore
          .collection('issues')
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      return IssueModel.fromJson({
        'id': snapshot.first.id,
        ...snapshot.first.map,
      });
    } catch (e) {
      log('Error getting latest issues: $e');
      rethrow;
    }
  }

  Future<Map<String, String>> getLatestVolumeAndIssueName() async {
    try {
      final volume = await getLatestVolume();
      final issue = await getLatestIssue();
      final year = volume.createdAt.year;

      return {
        'volume': volume.volumeNumber,
        'issue': issue.issueNumber,
        'year': year.toString(),
        'volumeId': volume.id,
        'issueId': issue.id,
      };
    } catch (e) {
      log('Error getting latest volume and issue name: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>?> getJournalAboutContent(String journalId) async {
    try {
      final doc = await _firestore
          .collection('journal-info')
          .document(journalId)
          .get();
      return doc.map;
    } catch (e) {
      log('Error getting journal about content: $e');
      return null;
    }
  }
}
