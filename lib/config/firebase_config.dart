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
  static const String projectId = 'journal-3c895';
  // Add other Firebase configuration as needed
}