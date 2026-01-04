
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCGpJnaR7wJPVDscB5gHqxZyjEId4woO1I',
    appId: '1:737063805016:web:a59ec36b303d3135df2a2d',
    messagingSenderId: '737063805016',
    projectId: 'gonzomotors-2de6f',
    authDomain: 'gonzomotors-2de6f.firebaseapp.com',
    storageBucket: 'gonzomotors-2de6f.firebasestorage.app',
    measurementId: 'G-LQ9BCZQZ4J',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCAmhYGRtfQLjhdgZnnvd8vGN82Gj0cRqM',
    appId: '1:737063805016:android:be38c9b5e0159cd7df2a2d',
    messagingSenderId: '737063805016',
    projectId: 'gonzomotors-2de6f',
    storageBucket: 'gonzomotors-2de6f.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDWUBw-UBvGAxiTZ4HfAQnIMFlmdEGCcXo',
    appId: '1:737063805016:ios:dfa8076bdd9c0641df2a2d',
    messagingSenderId: '737063805016',
    projectId: 'gonzomotors-2de6f',
    storageBucket: 'gonzomotors-2de6f.firebasestorage.app',
    iosBundleId: 'com.hursand.gonzomotors',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDWUBw-UBvGAxiTZ4HfAQnIMFlmdEGCcXo',
    appId: '1:737063805016:ios:095ad1d6a93dafffdf2a2d',
    messagingSenderId: '737063805016',
    projectId: 'gonzomotors-2de6f',
    storageBucket: 'gonzomotors-2de6f.firebasestorage.app',
    iosBundleId: 'com.gonzomotors',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCGpJnaR7wJPVDscB5gHqxZyjEId4woO1I',
    appId: '1:737063805016:web:9c2b4ecfa7ed9ddedf2a2d',
    messagingSenderId: '737063805016',
    projectId: 'gonzomotors-2de6f',
    authDomain: 'gonzomotors-2de6f.firebaseapp.com',
    storageBucket: 'gonzomotors-2de6f.firebasestorage.app',
    measurementId: 'G-DBZGH5BQ3J',
  );

}