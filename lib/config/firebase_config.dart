import 'package:dart_main_website/env/env.dart';
import 'package:firedart/firedart.dart';

void initializeFirestore() {
  Firestore.initialize(FirebaseConfig.projectId);
  // Note: API key not available in service account credentials
  // Would need separate configuration for client auth
  // FirebaseAuth.initialize(apiKey, VolatileStore());
}

Firestore getFirestore() {
  return Firestore.instance;
}

class FirebaseConfig {
  static const String projectId = Env.projectId;
  // Add other Firebase configuration as needed
}
