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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDM2u6PJEfoTNJoXUyMqKRSsHEV48a3_Dk',
    appId: '1:589221277464:web:6ff2a826918fa20bc1f86d',
    messagingSenderId: '589221277464',
    projectId: 'asaanmakaan-ce7ea',
    authDomain: 'asaanmakaan-ce7ea.firebaseapp.com',
    storageBucket: 'asaanmakaan-ce7ea.appspot.com',
    measurementId: 'G-YXXMB22422',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDQ64WjgoZzRVXhVkR5uneMqWTJcH1VIuY',
    appId: '1:589221277464:android:f470959473535593c1f86d',
    messagingSenderId: '589221277464',
    projectId: 'asaanmakaan-ce7ea',
    storageBucket: 'asaanmakaan-ce7ea.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB-ltKwx_tAShJ77Bs1YV22lHYnMiPiBsA',
    appId: '1:589221277464:ios:2c9c2cc9b3608760c1f86d',
    messagingSenderId: '589221277464',
    projectId: 'asaanmakaan-ce7ea',
    storageBucket: 'asaanmakaan-ce7ea.appspot.com',
    iosBundleId: 'com.example.asaanmakaan',
  );
}