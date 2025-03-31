import 'dart:developer';

import 'package:dart_main_website/models/article.dart';
import 'package:dart_main_website/models/eb_board_model.dart';
import 'package:dart_main_website/models/issue.dart';
import 'package:dart_main_website/models/journal.dart';
import 'package:dart_main_website/models/home_content_model.dart';
import 'package:dart_main_website/models/page_model.dart';
import 'package:dart_main_website/models/volume.dart';
import 'package:firedart/firedart.dart';
import '../config/firebase_config.dart';
import '../models/social_link.dart';
import '../services/cache_service.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  late Firestore _firestore;
  final _cacheService = CacheService();
  Map<String, SocialLink>? _cachedSocialLinks;

  // Add getter for cached social links
  Map<String, SocialLink> get cachedSocialLinks => _cachedSocialLinks ?? {};

  factory FirestoreService() {
    return _instance;
  }

  FirestoreService._internal() {
    Firestore.initialize(FirebaseConfig.projectId);
    _firestore = Firestore.instance;
  }

  Future<List<JournalModel>> getJournals() async {
    try {
      final snapshot = await _firestore
          .collection('journals')
          .orderBy('createdAt', descending: true)
          .get();
      final journals =
          snapshot.map((doc) => JournalModel.fromJson(doc.map)).toList();
      return journals;
    } catch (e) {
      print('Error getting journals: $e');
      rethrow;
    }
  }

  Future<List<EditorialBoardModel>> getEditorialBoardByJournalId(
      String journalId) async {
    try {
      final snapshot = await _firestore
          .collection('editorialBoard')
          .where('journalId', isEqualTo: journalId)
          .orderBy('role')
          .orderBy('name')
          .get();
      final editorialBoard =
          snapshot.map((doc) => EditorialBoardModel.fromJson(doc.map)).toList();

      editorialBoard.sort((a, b) {
        final roleOrder = {
          'Chief Editor': 0,
          'Associate Editor': 1,
          'Editor': 2
        };
        return (roleOrder[a.role] ?? 3).compareTo(roleOrder[b.role] ?? 3);
      });

      return editorialBoard;
    } catch (e) {
      log('Error getting editorial board by journal id: $e');
      return [];
    }
  }

  Future<PageModel?> getPageByDomain(String journalId, String pageRoute) async {
    try {
      final snapshot = await _firestore
          .collection('pages')
          .where('journalId', isEqualTo: journalId)
          .where('url', isEqualTo: pageRoute.trim())
          .get();

      return PageModel.fromJson(snapshot.first.map);
    } catch (e) {
      log('Error getting page by domain: $e');
      return null;
    }
  }

  Future<JournalModel?> getJournalByDomain(String domain) async {
    try {
      // Check cache first
      if (_cacheService.hasJournal(domain)) {
        return _cacheService.getJournal(domain);
      }

      // If not in cache, fetch from Firestore
      final journalDoc = await _firestore
          .collection('journals')
          .where('domain', isEqualTo: domain)
          .orderBy('createdAt', descending: true)
          .get();

      if (journalDoc.isEmpty) return null;

      final journal = JournalModel.fromJson(journalDoc.first.map);

      // Store in cache
      _cacheService.setJournal(domain, journal);

      return journal;
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
          .orderBy('volumeNumber', descending: true)
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
          .orderBy('issueNumber', descending: true)
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
          .orderBy('startPage')
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
          .orderBy('startPage')
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

      final data = {
        'id': doc.id,
        ...doc.map,
      };

      return IssueModel.fromJson(data);
    } catch (e) {
      log('Error getting issue by ID: $e');
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
          .orderBy('issueNumber', descending: true)
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
          .orderBy('startPage')
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
          .orderBy('volumeNumber', descending: true)
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
          .orderBy('issueNumber', descending: true)
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
      final doc =
          await _firestore.collection('journal-info').document(journalId).get();
      return doc.map;
    } catch (e) {
      log('Error getting journal about content: $e');
      return null;
    }
  }

  Future<String?> getPaperStatus(String paperId) async {
    try {
      final doc =
          await _firestore.collection('articles').document(paperId).get();

      return doc.map['status'];
    } catch (e) {
      log('Error getting paper status: $e');
      return null;
    }
  }

  Future<Map<String, SocialLink>> getSocialLinks() async {
    // Return cached links if available
    if (_cachedSocialLinks != null) {
      return _cachedSocialLinks!;
    }

    try {
      final socialLinks = <String, SocialLink>{};
      final platforms = ['facebook', 'instagram', 'linkedin', 'x', 'youtube'];

      for (final platform in platforms) {
        final doc =
            await _firestore.collection('socialLinks').document(platform).get();

        if (doc.map.isNotEmpty) {
          socialLinks[platform] = SocialLink.fromJson(doc.map);
        }
      }

      // Cache the results
      _cachedSocialLinks = socialLinks;
      return socialLinks;
    } catch (e) {
      log('Error getting social links: $e');
      return {};
    }
  }

  // Method to clear cache if needed
  void clearSocialLinksCache() {
    _cachedSocialLinks = null;
  }

  Future<VolumeModel?> getLatestVolumeByJournalId(String journalId) async {
    try {
      final snapshot = await _firestore
          .collection('volumes')
          .where('journalId', isEqualTo: journalId)
          .orderBy('volumeNumber', descending: true)
          .limit(1)
          .get();

      if (snapshot.isEmpty) return null;

      return VolumeModel.fromJson({
        'id': snapshot.first.id,
        ...snapshot.first.map,
      });
    } catch (e) {
      log('Error getting latest volume: $e');
      return null;
    }
  }

  Future<IssueModel?> getLatestIssueByVolumeId(String volumeId) async {
    try {
      final snapshot = await _firestore
          .collection('issues')
          .where('volumeId', isEqualTo: volumeId)
          .orderBy('issueNumber', descending: true)
          .limit(1)
          .get();

      if (snapshot.isEmpty) return null;

      return IssueModel.fromJson({
        'id': snapshot.first.id,
        ...snapshot.first.map,
      });
    } catch (e) {
      log('Error getting latest issue: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> getConfigDocument(String documentId) async {
    final docSnapshot =
        await _firestore.collection('configs').document(documentId).get();
    if (docSnapshot.map.isEmpty) {
      throw Exception('Config document $documentId not found');
    }
    return docSnapshot.map;
  }

  Future<List<dynamic>> getArticles(String journalId) async {
    try {
      final snapshot = await _firestore
          .collection('journals')
          .document(journalId)
          .collection('articles')
          .orderBy('startPage')
          .get();
      return snapshot
          .map((doc) => {
                'id': doc.id,
                'title': doc.map['title'] ?? '',
                'publishedDate': doc.map['publishedDate']?.toString(),
              })
          .toList();
    } catch (e) {
      print('Error fetching articles: $e');
      return [];
    }
  }

  Future<List<dynamic>> getVolumes(String journalId) async {
    try {
      final snapshot = await _firestore
          .collection('journals')
          .document(journalId)
          .collection('volumes')
          .get();
      return snapshot
          .map((doc) => {
                'id': doc.id,
              })
          .toList();
    } catch (e) {
      print('Error fetching volumes: $e');
      return [];
    }
  }

  Future<List<dynamic>> getIssues(String journalId, String volumeId) async {
    try {
      final snapshot = await _firestore
          .collection('journals')
          .document(journalId)
          .collection('volumes')
          .document(volumeId)
          .collection('issues')
          .get();
      return snapshot
          .map((doc) => {
                'id': doc.id,
              })
          .toList();
    } catch (e) {
      print('Error fetching issues: $e');
      return [];
    }
  }

  Future<HomeCountsModel> getHomeCounts() async {
    try {
      final totalArticles = (await _firestore
              .collection('articles')
              .where('status', isEqualTo: ArticleStatus.accepted.value)
              .get())
          .length;
      final totalJournals =
          (await _firestore.collection('journals').get()).length;
      final totalVolumes = (await _firestore
              .collection('volumes')
              .where('isActive', isEqualTo: true)
              .get())
          .length;
      final totalIssues = (await _firestore
              .collection('issues')
              .where('isActive', isEqualTo: true)
              .get())
          .length;
      final totalAuthors = (await _firestore
              .collection('users')
              .where('role', isEqualTo: 'author')
              .get())
          .length;
      return HomeCountsModel(
        totalArticles: totalArticles,
        totalJournals: totalJournals,
        totalVolumes: totalVolumes,
        totalIssues: totalIssues,
        totalAuthors: totalAuthors,
      );
    } catch (e) {
      log('Error getting home counts: $e');
      return HomeCountsModel(
        totalArticles: 0,
        totalJournals: 0,
        totalVolumes: 0,
        totalIssues: 0,
        totalAuthors: 0,
      );
    }
  }
}