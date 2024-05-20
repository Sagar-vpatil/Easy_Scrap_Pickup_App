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
    apiKey: 'AIzaSyCCexZQI6z-nJ1j4VSWxEzJyEY_KeWD87c',
    appId: '1:205060383774:web:850f9f10ae1171625dba0f',
    messagingSenderId: '205060383774',
    projectId: 'nda-project-ee4d3',
    authDomain: 'nda-project-ee4d3.firebaseapp.com',
    storageBucket: 'nda-project-ee4d3.appspot.com',
    measurementId: 'G-ECTTNX2KZ7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAmQ5o__GNqrOF3ixrI1yErynJFsh7Rd1Q',
    appId: '1:205060383774:android:9042cbbaa74e80495dba0f',
    messagingSenderId: '205060383774',
    projectId: 'nda-project-ee4d3',
    storageBucket: 'nda-project-ee4d3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCcAZ9Y0YjkRHwGxZGU8UTOLStFv0C27PA',
    appId: '1:205060383774:ios:7255aad8c1939f395dba0f',
    messagingSenderId: '205060383774',
    projectId: 'nda-project-ee4d3',
    storageBucket: 'nda-project-ee4d3.appspot.com',
    iosBundleId: 'com.example.ndaDemo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCcAZ9Y0YjkRHwGxZGU8UTOLStFv0C27PA',
    appId: '1:205060383774:ios:7255aad8c1939f395dba0f',
    messagingSenderId: '205060383774',
    projectId: 'nda-project-ee4d3',
    storageBucket: 'nda-project-ee4d3.appspot.com',
    iosBundleId: 'com.example.ndaDemo',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCCexZQI6z-nJ1j4VSWxEzJyEY_KeWD87c',
    appId: '1:205060383774:web:72a79e1c8b19a8625dba0f',
    messagingSenderId: '205060383774',
    projectId: 'nda-project-ee4d3',
    authDomain: 'nda-project-ee4d3.firebaseapp.com',
    storageBucket: 'nda-project-ee4d3.appspot.com',
    measurementId: 'G-F9R7DLEK4G',
  );
}