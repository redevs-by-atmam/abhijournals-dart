import 'package:shelf/shelf.dart';
import '../services/cache_service.dart';

Middleware cachingMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      // Get response from inner handler
      final response = await innerHandler(request);
      
      // Check if it's a navigation away or session end
      if (request.method == 'GET' && 
          (request.url.path == '/' || request.url.path.contains('logout'))) {
        CacheService().clearCache();
      }
      
      return response;
    };
  };
} 