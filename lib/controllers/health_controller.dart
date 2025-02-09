import 'package:shelf/shelf.dart';

class HealthController {
  Future<Response> check(Request request) async {
    return Response.ok('OK', headers: {'content-type': 'text/plain'});
  }
} 