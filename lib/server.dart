// ignore_for_file: unused_local_variable

import 'dart:io';
import 'package:mustache_template/mustache_template.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
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
    return renderError('An error occurred while processing your request: $e', data);
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

  // Add middleware
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(cachingMiddleware())
      .addHandler(app.call);

  // ... rest of server setup ...
}
