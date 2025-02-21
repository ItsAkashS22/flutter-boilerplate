import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticsService {
  static final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  /// Initializes Firebase Crashlytics
  static Future<void> initialize() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      logFlutterError(details);
    };
    if (!_crashlytics.isCrashlyticsCollectionEnabled) {
      await _crashlytics.setCrashlyticsCollectionEnabled(true);
    }
  }

  /// Logs a non-fatal error
  static Future<void> logError(
    dynamic error, {
    dynamic stackTrace,
    String? reason,
    String? endpoint,
    String? requestBody,
    String? responseBody,
    String? callingPage,
  }) async {
    await _crashlytics.recordError(
      error,
      stackTrace,
      reason: reason,
      fatal: false,
      information: [
        if (endpoint != null) 'Endpoint: $endpoint',
        if (requestBody != null) 'Request Body: $requestBody',
        if (responseBody != null) 'Response Body: $responseBody',
        if (callingPage != null) 'Calling Page: $callingPage',
      ],
    );
  }

  /// Logs a custom key-value pair
  static Future<void> setCustomKey(String key, dynamic value) async {
    await _crashlytics.setCustomKey(key, value);
  }

  /// Sets a custom user identifier
  static Future<void> setUserIdentifier(String identifier) async {
    await _crashlytics.setUserIdentifier(identifier);
  }

  /// Logs a message to Crashlytics
  static Future<void> log(String message) async {
    await _crashlytics.log(message);
  }

  /// Reports a caught Flutter exception
  static Future<void> logFlutterError(
      FlutterErrorDetails flutterErrorDetails) async {
    await _crashlytics.recordFlutterError(flutterErrorDetails);
  }
}
