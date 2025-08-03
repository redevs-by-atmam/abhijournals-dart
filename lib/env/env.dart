// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'FIREBASE_PROJECT_ID')
  static const String projectId = _Env.projectId;

  @EnviedField(varName: 'JOURNAL_DOMAIN')
  static const String journalDomain = _Env.journalDomain;

  @EnviedField(varName: 'JOURNAL_TITLE')
  static const String journalTitle = _Env.journalTitle;

  @EnviedField(varName: 'ILOVEPDF_SECRET_KEY')
  static const String ilovepdfSecretKey = _Env.ilovepdfSecretKey;

  @EnviedField(varName: 'ILOVEPDF_PUBLIC_KEY')
  static const String ilovepdfPublicKey = _Env.ilovepdfPublicKey;

  @EnviedField(varName: 'BASE_URL')
  static const String baseUrl = _Env.baseUrl;
}
