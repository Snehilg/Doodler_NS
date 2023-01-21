// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAuM3jeQ2Fu-cD9wh3NHcXPmyRj2XJ3e0I',
    appId: '1:1021088501582:web:c23f5d79ff3addf9d2d81f',
    messagingSenderId: '1021088501582',
    projectId: 'doodler-6fab7',
    authDomain: 'doodler-6fab7.firebaseapp.com',
    databaseURL: 'https://doodler-6fab7.firebaseio.com',
    storageBucket: 'doodler-6fab7.appspot.com',
    measurementId: 'G-TYSTLY2NHV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDcsq_MheXsHEChoUUbeSJVVH_CD7oS3TU',
    appId: '1:1021088501582:android:78880fe5a90690ddd2d81f',
    messagingSenderId: '1021088501582',
    projectId: 'doodler-6fab7',
    databaseURL: 'https://doodler-6fab7.firebaseio.com',
    storageBucket: 'doodler-6fab7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDHGVwb7_ZbqhWbgtmiCD0oX-G5H_j9d1g',
    appId: '1:1021088501582:ios:2bc726b1d121835fd2d81f',
    messagingSenderId: '1021088501582',
    projectId: 'doodler-6fab7',
    databaseURL: 'https://doodler-6fab7.firebaseio.com',
    storageBucket: 'doodler-6fab7.appspot.com',
    androidClientId: '1021088501582-61b45i8tpl3e7ijpo3d4kqec365nmm4j.apps.googleusercontent.com',
    iosClientId: '1021088501582-sb2cbj7jbkjvj651to58oulnnlej4glj.apps.googleusercontent.com',
    iosBundleId: 'com.example.doodler',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDHGVwb7_ZbqhWbgtmiCD0oX-G5H_j9d1g',
    appId: '1:1021088501582:ios:2bc726b1d121835fd2d81f',
    messagingSenderId: '1021088501582',
    projectId: 'doodler-6fab7',
    databaseURL: 'https://doodler-6fab7.firebaseio.com',
    storageBucket: 'doodler-6fab7.appspot.com',
    androidClientId: '1021088501582-61b45i8tpl3e7ijpo3d4kqec365nmm4j.apps.googleusercontent.com',
    iosClientId: '1021088501582-sb2cbj7jbkjvj651to58oulnnlej4glj.apps.googleusercontent.com',
    iosBundleId: 'com.example.doodler',
  );
}