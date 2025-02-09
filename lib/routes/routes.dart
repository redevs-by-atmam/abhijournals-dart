import 'package:shelf_router/shelf_router.dart';
import '../controllers/home_controller.dart';
import '../controllers/domain_controller.dart';

class Routes {
  Router get router {
    final router = Router();
    
    // Controllers
    final homeController = HomeController();
    final domainController = DomainController();

    // Routes
    router.get('/', homeController.index);
    router.get('/<domain>', domainController.index);
    router.get('/<domain>/', domainController.index);

    return router;
  }
} 