// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(
      varName: 'FIREBASE_PROJECT_ID', defaultValue: 'your-project-id-here')
  static const String projectId = _Env.projectId;

  static const firebaseProjectId = String.fromEnvironment('FIREBASE_PROJECT_ID',
      defaultValue: 'default-project-id');

  static const baseUrl = String.fromEnvironment('BASE_URL',
      defaultValue: 'https://abhijournals.com');
}
