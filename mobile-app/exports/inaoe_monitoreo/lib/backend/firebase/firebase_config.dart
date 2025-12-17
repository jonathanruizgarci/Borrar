import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyArEo2-41WbGlUoGvh-qvTq5BsWnTbZ6ZQ",
            authDomain: "inaoe-monitoreo-pl7tbv.firebaseapp.com",
            projectId: "inaoe-monitoreo-pl7tbv",
            storageBucket: "inaoe-monitoreo-pl7tbv.firebasestorage.app",
            messagingSenderId: "1078944079121",
            appId: "1:1078944079121:web:8a919199901c9e50d480b0"));
  } else {
    await Firebase.initializeApp();
  }
}
