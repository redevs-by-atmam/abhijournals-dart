import 'package:dart_main_website/config/layout.html.dart';
import 'package:shelf/shelf.dart';
import '../services/firestore_service.dart';
import '../server.dart';

class JournalInfoController {
  final _firestoreService = FirestoreService();

  Future<Response> aboutJournal(Request request, String domain) async {
    try {
      final journal = await _firestoreService.getJournalByDomain(domain);
      final aboutContent = await _firestoreService.getPageByDomain(journal!.id, 'about-journal');

      return renderHtml('dynamic-pages/page.html', {
        'header': getHeaderHtml(journal),
        'footer': getFooterHtml(journal),
        'journal': journal.toJson(),
        'domain': journal.domain,
        'content': aboutContent!.toJson(),
      });
    } catch (e) {
      print('Error fetching about journal: $e');
      return Response.internalServerError(
          body: 'An error occurred while processing your request');
    }
  }

  Future<Response> aimAndScope(Request request, String domain) async {
    try {
      final journal = await _firestoreService.getJournalByDomain(domain);
      final aimAndScopeContent = await _firestoreService.getPageByDomain(journal!.id, 'aim-and-scope');

      return renderHtml('dynamic-pages/page.html', {
        'header': getHeaderHtml(journal),
        'footer': getFooterHtml(journal),
        'journal': journal.toJson(),
        'domain': journal.domain,
        'content': aimAndScopeContent?.toJson(),
      });
    } catch (e) {
      print('Error fetching aim and scope: $e');
      return Response.internalServerError(
          body: 'An error occurred while processing your request');
    }
  }

  Future<Response> editorialBoard(Request request, String domain) async {
    try {
      final journal = await _firestoreService.getJournalByDomain(domain);
      final editorialBoardContent = await _firestoreService.getPageByDomain(journal!.id, 'editorial-board');

      return renderHtml('dynamic-pages/page.html', {
        'header': getHeaderHtml(journal),
        'footer': getFooterHtml(journal),
        'journal': journal.toJson(),
        'domain': journal.domain,
        'content': editorialBoardContent?.toJson(),
      });
    } catch (e) {
      print('Error fetching editorial board: $e');
      return Response.internalServerError(
          body: 'An error occurred while processing your request');
    }
  }

  Future<Response> publicationEthics(Request request, String domain) async {
    try {
      final journal = await _firestoreService.getJournalByDomain(domain);
      final publicationEthicsContent = await _firestoreService.getPageByDomain(journal!.id, 'publication-ethics');

      return renderHtml('dynamic-pages/page.html', {
        'header': getHeaderHtml(journal),
        'footer': getFooterHtml(journal),
        'journal': journal.toJson(),
        'domain': journal.domain,
        'content': publicationEthicsContent?.toJson(),
      });
    } catch (e) {
      print('Error fetching publication ethics: $e');
      return Response.internalServerError(
          body: 'An error occurred while processing your request');
    }
  }

  Future<Response> indexingAndAbstracting(Request request, String domain) async {
    try {
      final journal = await _firestoreService.getJournalByDomain(domain);
      final indexingContent = await _firestoreService.getPageByDomain(journal!.id, 'indexing-and-abstracting');

      return renderHtml('dynamic-pages/page.html', {
        'header': getHeaderHtml(journal),
        'footer': getFooterHtml(journal),
        'journal': journal.toJson(),
        'domain': journal.domain,
        'content': indexingContent?.toJson(),
      });
    } catch (e) {
      print('Error fetching indexing and abstracting: $e');
      return Response.internalServerError(
          body: 'An error occurred while processing your request');
    }
  }

  Future<Response> peerReviewProcess(Request request, String domain) async {
    try {
      final journal = await _firestoreService.getJournalByDomain(domain);
      final peerReviewContent = await _firestoreService.getPageByDomain(journal!.id, 'peer-review-process');

      return renderHtml('dynamic-pages/page.html', {
        'header': getHeaderHtml(journal),
        'footer': getFooterHtml(journal),
        'journal': journal.toJson(),
        'domain': journal.domain,
        'content': peerReviewContent?.toJson(),
      });
    } catch (e) {
      print('Error fetching peer review process: $e');
      return Response.internalServerError(
          body: 'An error occurred while processing your request');
    }
  }
} 