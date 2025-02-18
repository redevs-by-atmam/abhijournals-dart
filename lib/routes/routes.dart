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

    // Routes
    router.get('/', homeController.index);
    router.get('/<domain>', domainController.index);
    router.get('/<domain>/', domainController.index);
    router.get('/<domain>/issue/<issueId>/articles/',
        issueController.getArticles);
    router.get('/<domain>/issue/<issueId>/articles',
        issueController.getArticles);
    router.get('/<domain>/article/<articleId>/', articleController.show);
    router.get('/<domain>/archive/', archiveController.index);
    router.get('/<domain>/archive/volume/<volumeId>/issues/',
        archiveController.showVolumeIssues);
    router.get('/<domain>/current-issue/', currentIssueController.index);
    router.get('/<domain>/by-issue/', currentIssueController.byIssue);

    // Journal Info Routes
    router.get('/<domain>/about-journal/', journalInfoController.aboutJournal);
    router.get('/<domain>/aim-and-scope/', journalInfoController.aimAndScope);
    router.get(
        '/<domain>/editorial-board/', journalInfoController.editorialBoard);
    router.get('/<domain>/publication-ethics/',
        journalInfoController.publicationEthics);
    router.get('/<domain>/indexing-and-abstracting/',
        journalInfoController.indexingAndAbstracting);
    router.get('/<domain>/peer-review-process/',
        journalInfoController.peerReviewProcess);

    // Author Resources Routes
    router.get('/<domain>/submit-online-paper/',
        authorResourcesController.submitOnlinePaper);
    router.get('/<domain>/topics/', authorResourcesController.topics);
    router.get('/<domain>/author-guidelines/',
        authorResourcesController.authorGuidelines);
    router.get(
        '/<domain>/copyright-form/', authorResourcesController.copyrightForm);
    router.get('/<domain>/check-paper-status/',
        authorResourcesController.checkPaperStatus);
    router.get('/<domain>/submit-manuscript/',
        authorResourcesController.submitManuscript);
    router.get('/<domain>/reviewers/', authorResourcesController.reviewers);
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
