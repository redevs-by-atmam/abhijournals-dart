import 'package:dart_main_website/config/layout.html.dart';
import 'package:shelf/shelf.dart';
import '../services/firestore_service.dart';
import '../server.dart';
import 'dart:convert';

class AuthorResourcesController {
  final _firestoreService = FirestoreService();

  Future<Response> submitOnlinePaper(Request request, String domain) async {
    try {
      final journal = await _firestoreService.getJournalByDomain(domain);
      final pageContent = await _firestoreService.getPageByDomain(
          journal!.id, 'submit-online-paper');

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
      final pageContent =
          await _firestoreService.getPageByDomain(journal!.id, 'topics');

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
      final pageContent = await _firestoreService.getPageByDomain(
          journal!.id, 'author-guidelines');

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
      final pageContent = await _firestoreService.getPageByDomain(
          journal!.id, 'copyright-form');

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
      if (journal == null) {
        return renderNotFound({
          'domain': domain,
        });
      }

      // Get paperId from query parameter if present
      final paperId = request.url.queryParameters['paperId'];
      String? status;
      String? error;

      // If paperId is provided, fetch the status
      if (paperId != null && paperId.isNotEmpty) {
        status = await _firestoreService.getPaperStatus(paperId);
        if (status == null) {
          error = 'Paper not found. Please check the ID and try again.';
        }
      }

      return renderHtml('dynamic-pages/check-paper-status.html', {
        'header': getHeaderHtml(journal),
        'footer': getFooterHtml(journal),
        'journal': journal.toJson(),
        'domain': journal.domain,
        'paperId': paperId,
        'status': status,
        'error': error,
      });
    } catch (e) {
      print('Error checking paper status: $e');
      return renderError(
        'An error occurred while checking the paper status',
        {'domain': domain}
      );
    }
  }

  Future<Response> submitManuscript(Request request, String domain) async {
    try {
      final journal = await _firestoreService.getJournalByDomain(domain);
      final pageContent = await _firestoreService.getPageByDomain(
          journal!.id, 'submit-manuscript');

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
      final pageContent =
          await _firestoreService.getPageByDomain(journal!.id, 'reviewer');

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

  // Add API endpoint for paper status check
  Future<Response> getPaperStatus(Request request, String paperId) async {
    try {
      final paperStatus = await _firestoreService.getPaperStatus(paperId);

      if (paperStatus == null) {
        return Response.notFound(
            json.encode({
              'message': 'Paper not found. Please check the ID and try again.'
            }),
            headers: {'content-type': 'application/json'});
      }

      return Response.ok(paperStatus,
          headers: {'content-type': 'application/json'});
    } catch (e) {
      print('Error checking paper status: $e');
      return Response.internalServerError(
          body: json.encode(
              {'message': 'An error occurred while checking the paper status'}),
          headers: {'content-type': 'application/json'});
    }
  }
}
