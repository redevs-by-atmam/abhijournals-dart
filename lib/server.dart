import 'dart:io';
import 'package:mustache_template/mustache_template.dart';
import 'package:shelf/shelf.dart';

Future<Response> renderHtml(String template, Map<String, dynamic> data) async {
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
}

Future<String> _loadTemplate(String name) async {
  final file = File('templates/$name');
  return await file.readAsString();
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


