import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart';
import 'routes/routes.dart';

void main() async {
  // Initialize routes
  final routes = Routes();
  
  // Create middleware pipeline
  final pipeline = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(routes.router.call);

  // Setup static file handler
  final static = createStaticHandler('static');

  // Create cascade
  final cascade = Cascade()
      .add(static)
      .add(pipeline);

  // Start server
  final server = await shelf_io.serve(
    cascade.handler,
    '0.0.0.0',
    8080,
  );

  print('Server running on http://localhost:${server.port}');
}
