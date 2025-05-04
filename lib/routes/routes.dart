import 'package:dart_main_website/controllers/pdf_download_controller.dart';
import 'package:dart_main_website/server.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../controllers/home_controller.dart';
import '../controllers/domain_controller.dart';
import '../controllers/issue_controller.dart';
import '../controllers/article_controller.dart';
import '../controllers/archive_controller.dart';
import '../controllers/current_issue_controller.dart';
import '../controllers/journal_info_controller.dart';
import '../controllers/author_resources_controller.dart';
import '../controllers/contact_controller.dart';

class Routes {
  Router get router {
    final router = Router();

    // Controllers
    final homeController = HomeController();
    final domainController = DomainController();
    final issueController = IssueController();
    final articleController = ArticleController();
    final archiveController = ArchiveController();
    final currentIssueController = CurrentIssueController();
    final journalInfoController = JournalInfoController();
    final authorResourcesController = AuthorResourcesController();
    final contactController = ContactController();
    final pdfDownloadController = PdfDownloadController();

    // Routes

    // Home Route
    router.get('/', homeController.index);

    // Domain Route
    router.get('/<domain>', domainController.index);
    router.get('/<domain>/', domainController.index);

    // Issue Route
    router.get(
        '/<domain>/issue/<issueId>/articles/', issueController.getArticles);
    router.get(
        '/<domain>/issue/<issueId>/articles', issueController.getArticles);

    // download issue as pdf route
    router.get('/<domain>/issue/<issueId>/articles/download/',
        pdfDownloadController.downloadPdf);

    // Article Route
    router.get('/<domain>/article/<articleId>/', articleController.show);
    router.get('/<domain>/article/<articleId>', articleController.show);

    // Article PDF Route
    router.get(
        '/<domain>/article/<articleId>/<pdfTitle>.pdf', articleController.pdf);

    // Archive Route
    router.get('/<domain>/archive/', archiveController.index);

    // All Issues of Volume of Journal Route
    router.get('/<domain>/archive/volume/<volumeId>/issues/',
        archiveController.showVolumeIssues);

    // Current Issue Route
    router.get('/<domain>/current-issue/', currentIssueController.index);

    // By Issue Route
    router.get('/<domain>/by-issue/', currentIssueController.byIssue);

    // Journal Info Routes
    router.get('/<domain>/about-journal/', journalInfoController.aboutJournal);

    // Journal Aim and Scope Route
    router.get('/<domain>/aim-and-scope/', journalInfoController.aimAndScope);

    // Journal Editorial Board Route
    router.get(
        '/<domain>/editorial-board/', journalInfoController.editorialBoard);

    // Journal Publication Ethics Route
    router.get('/<domain>/publication-ethics/',
        journalInfoController.publicationEthics);

    // Journal Indexing and Abstracting Route

    router.get(
        '/<domain>/indexing-and-abstracting/',

        // Journal Peer Review Process Route
        journalInfoController.indexingAndAbstracting);

    // Journal Peer Review Process Route
    router.get('/<domain>/peer-review-process/',
        journalInfoController.peerReviewProcess);

    // Author Resources Routes
    router.get('/<domain>/submit-online-paper/',
        authorResourcesController.submitOnlinePaper);

    // Journal Topics Route
    router.get('/<domain>/topics/', authorResourcesController.topics);

    // Journal Author Guidelines Route

    router.get(
        '/<domain>/author-guidelines/',

        // Journal Copyright Form Route
        authorResourcesController.authorGuidelines);
    router.get(
        '/<domain>/copyright-form/', authorResourcesController.copyrightForm);

    // Journal Check Paper Status Route
    router.get('/<domain>/check-paper-status/',
        authorResourcesController.checkPaperStatus);

    // Journal Submit Manuscript Route
    router.get('/<domain>/submit-manuscript/',
        authorResourcesController.submitManuscript);

    // Journal Reviewers Route
    router.get('/<domain>/reviewers/', authorResourcesController.reviewers);

    // Journal Get Paper Status Route
    router.get('/api/paper-status/<paperId>',
        authorResourcesController.getPaperStatus);

    // Contact Route
    router.get('/<domain>/contact/', contactController.index);

    // Add catch-all route for 404s
    router.all('/<ignored|.*>', (Request request, String ignored) async {
      final uri = request.requestedUri;
      final domain = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '';

      return renderNotFound({
        'domain': domain,
      });
    });

    return router;
  }
}
