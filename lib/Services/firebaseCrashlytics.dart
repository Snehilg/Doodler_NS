class FirebaseCrashlytics {
  FirebaseCrashlytics.initialize() {
    // Set `enableInDevMode` to true to see reports while in debug mode
    // This is only to be used for confirming that reports are being
    // submitted as expected. It is not intended to be used for everyday
    // development.
    // FirebaseCrashlytics..instance.enableInDevMode = true;

    // Pass all uncaught errors from the framework to Crashlytics.
    //FlutterError.onError = Crashlytics.instance.recordFlutterError;
  }
}
