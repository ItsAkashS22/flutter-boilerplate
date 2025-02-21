import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
    analytics: _analytics,
  );

  // Initialize Firebase Analytics
  static Future<void> initialize() async {
    if (await _analytics.isSupported()) {
      await _analytics.setAnalyticsCollectionEnabled(true);
    }
  }

  // Log a simple event
  static Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  // Set user ID
  static Future<void> setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
  }

  // Set user properties
  static Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    await _analytics.setUserProperty(
      name: name,
      value: value,
    );
  }

  // Log API request
  static Future<void> logApiRequest({
    required String endpoint,
    required String method,
    int? responseCode,
    int? responsePayloadSize,
    int? requestPayloadSize,
    String? responseContentType,
  }) async {
    await _analytics.logEvent(
      name: 'api_request',
      parameters: {
        'endpoint': endpoint,
        'method': method,
        'response_code': responseCode ?? 'unknown',
        'response_payload_size': responsePayloadSize ?? 0,
        'request_payload_size': requestPayloadSize ?? 0,
        'response_content_type': responseContentType ?? 'unknown',
      },
    );
  }
}
