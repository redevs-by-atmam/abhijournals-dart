// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
    @EnviedField(varName: 'FIREBASE_PROJECT_ID', defaultValue: 'your-project-id-here')
    static const String projectId = _Env.projectId;

}