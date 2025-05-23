// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
    apiKey: 'AIzaSyAfxZbl4UR-b1gX2CTC_vQuBpjsWgsRQCs',
    appId: '1:232402821339:web:ae94f651af52aa940a2cfe',
    messagingSenderId: '232402821339',
    projectId: 'smart-uv-exposure-tracker',
    authDomain: 'smart-uv-exposure-tracker.firebaseapp.com',
    storageBucket: 'smart-uv-exposure-tracker.firebasestorage.app',
    measurementId: 'G-5Z02DJ5HBN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAcunYKkIrUB1WKnm4E_BVXNXo3FOXVCeI',
    appId: '1:232402821339:android:bf8b056ea9cb48000a2cfe',
    messagingSenderId: '232402821339',
    projectId: 'smart-uv-exposure-tracker',
    storageBucket: 'smart-uv-exposure-tracker.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBfEtP-pmQ5hLxu3UbzSB07u6rZNzmPPAw',
    appId: '1:232402821339:ios:04aebf174c00a97b0a2cfe',
    messagingSenderId: '232402821339',
    projectId: 'smart-uv-exposure-tracker',
    storageBucket: 'smart-uv-exposure-tracker.firebasestorage.app',
    iosBundleId: 'top.flareline.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBfEtP-pmQ5hLxu3UbzSB07u6rZNzmPPAw',
    appId: '1:232402821339:ios:04aebf174c00a97b0a2cfe',
    messagingSenderId: '232402821339',
    projectId: 'smart-uv-exposure-tracker',
    storageBucket: 'smart-uv-exposure-tracker.firebasestorage.app',
    iosBundleId: 'top.flareline.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAfxZbl4UR-b1gX2CTC_vQuBpjsWgsRQCs',
    appId: '1:232402821339:web:613c2c7e3315875e0a2cfe',
    messagingSenderId: '232402821339',
    projectId: 'smart-uv-exposure-tracker',
    authDomain: 'smart-uv-exposure-tracker.firebaseapp.com',
    storageBucket: 'smart-uv-exposure-tracker.firebasestorage.app',
    measurementId: 'G-QS15MEXB2P',
  );
}
