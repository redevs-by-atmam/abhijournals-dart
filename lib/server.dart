// ignore_for_file: unused_local_variable

import 'dart:io';
import 'package:dart_main_website/controllers/home_controller.dart';
import 'package:dart_main_website/env/env.dart';
import 'package:dart_main_website/services/firestore_service.dart';
import 'package:mustache_template/mustache_template.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';
import 'middleware/cache_middleware.dart';
// import 'package:abhi_international_journals/services/firestore_service.dart';

Future<Response> renderHtml(String template, Map<String, dynamic> data) async {
  try {
    // Add common data available to all templates
    final commonData = {
      ...data,
      'site_name': 'Abhi International Journals',
      'current_year': DateTime.now().year.toString(),
      'navigation': _buildNavigation(data),
    };

    // Load and parse the template
    final templateContent = await _loadTemplate(template);
    final parser = Template(templateContent, name: template);

    // Render the template
    final output = parser.renderString(commonData);

    return Response.ok(output, headers: {
      'content-type': 'text/html',
    });
  } catch (e, stackTrace) {
    print('Error rendering template: $e');
    print('Stack trace: $stackTrace');
    return renderError(
        'An error occurred while processing your request: $e', data);
  }
}

Future<Response> renderNotFound(Map<String, dynamic> data) async {
  try {
    final templateContent = await _loadTemplate('dynamic-pages/not-found.html');
    final parser = Template(templateContent);
    final output = parser.renderString(data);

    return Response.notFound(output, headers: {
      'content-type': 'text/html',
    });
  } catch (e, stackTrace) {
    print('Error rendering not found page: $e');
    print('Stack trace: $stackTrace');
    return Response.notFound('Page not found');
  }
}

Future<Response> renderError(
    String errorMessage, Map<String, dynamic> data) async {
  try {
    final templateContent = await _loadTemplate('dynamic-pages/error.html');
    final parser = Template(templateContent);
    final output = parser.renderString({
      ...data,
      'error': errorMessage,
    });

    return Response.internalServerError(
      body: output,
      headers: {'content-type': 'text/html'},
    );
  } catch (e, stackTrace) {
    print('Error rendering error page: $e');
    print('Stack trace: $stackTrace');
    return Response.internalServerError(
      body: 'An error occurred while processing your request',
    );
  }
}

Future<String> _loadTemplate(String name) async {
  try {
    final file = File('templates/$name');
    if (!await file.exists()) {
      throw Exception('Template file does not exist: templates/$name');
    }
    final content = await file.readAsString();
    if (content.isEmpty) {
      throw Exception('Template file is empty: templates/$name');
    }
    return content;
  } catch (e, stackTrace) {
    print('Error loading template $name: $e');
    print('Stack trace: $stackTrace');
    rethrow;
  }
}

String _buildNavigation(Map<String, dynamic> data) {
  // Build navigation based on context
  if (data.containsKey('journal')) {
    // Journal-specific navigation
    return '''
      <ul>
        <li><a href="/">Home</a></li>
        <li><a href="/articles">Articles</a></li>
        <li><a href="/submit">Submit</a></li>
        <li><a href="/contact">Contact</a></li>
      </ul>
    ''';
  }

  // Main site navigation
  return '''
    <ul>
      <li><a href="/" class="active">Home</a></li>
      <li><a href="/about">About</a></li>
      <li><a href="/journals">Journals</a></li>
      <li><a href="/contact">Contact</a></li>
    </ul>
  ''';
}

void main() async {
  final app = Router();
  final firestoreService = FirestoreService();
  final projectId = Env.projectId;

  // Add middleware pipeline
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(cachingMiddleware())
      .addHandler((request) async {
    final path = request.url.path;

    // Add debug logging
    print('Current Firebase Project ID: $projectId');
    print('Contains "janoli": ${projectId.toLowerCase().contains('janoli')}');

    // Handle SEO files based on project ID
    if (path == 'robots.txt' || path == '/robots.txt') {
      final robotsFile = projectId.toLowerCase().contains('janoli')
          ? 'static/janoli-robots.txt'
          : 'static/robots.txt';
      print('Selected robots file: $robotsFile');
      return _serveStaticFile(robotsFile, 'text/plain');
    }

    if (path == 'sitemap.xml' || path == '/sitemap.xml') {
      final sitemapFile = projectId.toLowerCase().contains('janoli')
          ? 'static/janoli-sitemap.xml'
          : 'static/sitemap.xml';
      print('Selected sitemap file: $sitemapFile');
      return _serveStaticFile(sitemapFile, 'application/xml');
    }

    // Handle other static files
    if (path.startsWith('static/')) {
      final staticHandler = createStaticHandler('static/');
      return staticHandler(request);
    }

    // Handle all other routes
    return app(request);
  });

  // Create server
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, InternetAddress.anyIPv4, port);
  print('Server running on http://localhost:${server.port}');
}

Future<Response> _serveStaticFile(String filePath, String contentType) async {
  try {
    final file = File(filePath);
    if (await file.exists()) {
      final content = await file.readAsString();
      return Response.ok(
        content,
        headers: {
          'content-type': '$contentType; charset=utf-8',
          'cache-control': 'public, max-age=3600',
        },
      );
    }
    return Response.notFound('File not found');
  } catch (e) {
    print('Error serving static file: $e');
    return Response.internalServerError();
  }
}

// Update the caching middleware
Middleware cachingMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      final response = await innerHandler(request);

      // Add caching headers for SEO files
      if (request.url.path == 'robots.txt' ||
          request.url.path == 'sitemap.xml') {
        return response.change(
          headers: {
            ...response.headers,
            'cache-control': 'public, max-age=3600',
            'vary': 'Accept-Encoding',
          },
        );
      }

      return response;
    };
  };
}
