import 'package:dart_main_website/config/layout.html.dart';
import 'package:shelf/shelf.dart';
import '../services/firestore_service.dart';
import '../server.dart';

class AuthorResourcesController {
  final _firestoreService = FirestoreService();

  Future<Response> submitOnlinePaper(Request request, String domain) async {
    try {
      final journal = await _firestoreService.getJournalByDomain(domain);
      final pageContent = await _firestoreService.getPageByDomain(journal!.id, 'submit-online-paper');

      return renderHtml('dynamic-pages/page.html', {
        'header': getHeaderHtml(journal),
        'footer': getFooterHtml(journal),
        'journal': journal.toJson(),
        'domain': journal.domain,
        'content': pageContent?.toJson(),
      });
    } catch (e) {
      print('Error fetching submission page: $e');
      return Response.internalServerError(
          body: 'An error occurred while processing your request');
    }
  }

  Future<Response> topics(Request request, String domain) async {
    try {
      final journal = await _firestoreService.getJournalByDomain(domain);
      final pageContent = await _firestoreService.getPageByDomain(journal!.id, 'topics');

      return renderHtml('dynamic-pages/page.html', {
        'header': getHeaderHtml(journal),
        'footer': getFooterHtml(journal),
        'journal': journal.toJson(),
        'domain': journal.domain,
        'content': pageContent?.toJson(),
      });
    } catch (e) {
      print('Error fetching topics: $e');
      return Response.internalServerError(
          body: 'An error occurred while processing your request');
    }
  }

  Future<Response> authorGuidelines(Request request, String domain) async {
    try {
      final journal = await _firestoreService.getJournalByDomain(domain);
      final pageContent = await _firestoreService.getPageByDomain(journal!.id, 'author-guidelines');

      return renderHtml('dynamic-pages/page.html', {
        'header': getHeaderHtml(journal),
        'footer': getFooterHtml(journal),
        'journal': journal.toJson(),
        'domain': journal.domain,
        'content': pageContent?.toJson(),
      });
    } catch (e) {
      print('Error fetching author guidelines: $e');
      return Response.internalServerError(
          body: 'An error occurred while processing your request');
    }
  }
  Future<Response> copyrightForm(Request request, String domain) async {
    try {
      final journal = await _firestoreService.getJournalByDomain(domain);
      final pageContent = await _firestoreService.getPageByDomain(journal!.id, 'copyright-form');

      return renderHtml('dynamic-pages/page.html', {
        'header': getHeaderHtml(journal),
        'footer': getFooterHtml(journal),
        'journal': journal.toJson(),
        'domain': journal.domain,
        'content': pageContent?.toJson(),
      });
    } catch (e) {
      print('Error fetching copyright form: $e');
      return Response.internalServerError(
          body: 'An error occurred while processing your request');
    }
  }

  Future<Response> checkPaperStatus(Request request, String domain) async {
    try {
      final journal = await _firestoreService.getJournalByDomain(domain);
      final pageContent = await _firestoreService.getPageByDomain(journal!.id, 'check-paper-status');

      return renderHtml('dynamic-pages/page.html', {
        'header': getHeaderHtml(journal),
        'footer': getFooterHtml(journal),
        'journal': journal.toJson(),
        'domain': journal.domain,
        'content': pageContent?.toJson(),
      });
    } catch (e) {
      print('Error fetching paper status page: $e');
      return Response.internalServerError(
          body: 'An error occurred while processing your request');
    }
  }

  Future<Response> submitManuscript(Request request, String domain) async {
    try {
      final journal = await _firestoreService.getJournalByDomain(domain);
      final pageContent = await _firestoreService.getPageByDomain(journal!.id, 'submit-manuscript');

      return renderHtml('dynamic-pages/page.html', {
        'header': getHeaderHtml(journal),
        'footer': getFooterHtml(journal),
        'journal': journal.toJson(),
        'domain': journal.domain,
        'content': pageContent?.toJson(),
      });
    } catch (e) {
      print('Error fetching manuscript submission page: $e');
      return Response.internalServerError(
          body: 'An error occurred while processing your request');
    }
  }

  Future<Response> reviewers(Request request, String domain) async {
    try {
      final journal = await _firestoreService.getJournalByDomain(domain);
        final pageContent = await _firestoreService.getPageByDomain(journal!.id, 'reviewers');

      return renderHtml('dynamic-pages/page.html', {
        'header': getHeaderHtml(journal),
        'footer': getFooterHtml(journal),
        'journal': journal.toJson(),
        'domain': journal.domain,
        'content': pageContent?.toJson(),
      });
    } catch (e) {
      print('Error fetching reviewers page: $e');
      return Response.internalServerError(
          body: 'An error occurred while processing your request');
    }
  }
  // Similar methods for other author resources pages...
} 