import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Configuration {
  static late Flavor flavor;
  static late FirebaseOptions firebaseOptions;
  static late String baseUrl;

  static Future<void> initializeConfigurations() async {
    flavor = Flavor.values.byName(appFlavor ?? Flavor.prod.name);
    await dotenv.load(fileName: "env/${flavor.name}/.env");
    firebaseOptions = FirebaseOptions(
      apiKey: Platform.isAndroid
          ? dotenv.get("API_KEY_ANDROID")
          : dotenv.get("API_KEY_IOS"),
      appId: Platform.isAndroid
          ? dotenv.get("APP_ID_ANDROID")
          : dotenv.get("APP_ID_IOS"),
      messagingSenderId: dotenv.get("MESSAGING_SENDER_ID"),
      projectId: dotenv.get("PROJECT_ID"),
      iosBundleId: dotenv.get("IOS_BUNDLE_ID"),
    );
    baseUrl = dotenv.get("BASE_URL");
  }
}

enum Flavor {
  dev,
  stg,
  prod,
}
