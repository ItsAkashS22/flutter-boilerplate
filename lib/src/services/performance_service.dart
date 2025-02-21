import 'package:firebase_performance/firebase_performance.dart';
import 'crashlytics_service.dart';

class PerformanceService {
  static final FirebasePerformance _performance = FirebasePerformance.instance;

  // Initialize Firebase Performance
  static Future<void> initialize() async {
    if (!(await _performance.isPerformanceCollectionEnabled())) {
      await _performance.setPerformanceCollectionEnabled(true);
    }
  }

  // Start a custom trace
  static Trace startTrace(String traceName) {
    final Trace trace = _performance.newTrace(traceName);
    trace.start();
    return trace;
  }

  // Stop a custom trace
  static Future<void> stopTrace(Trace trace) async {
    try {
      await trace.stop();
    } catch (e) {
      _logError('stopTrace', e);
    }
  }

  // Start an HTTP metric
  static HttpMetric startHttpMetric(String url, HttpMethod method) {
    final HttpMetric httpMetric = _performance.newHttpMetric(url, method);
    httpMetric.start();
    return httpMetric;
  }

  // Stop an HTTP metric and log details
  static Future<void> stopHttpMetric({
    required HttpMetric httpMetric,
    required int httpResponseCode,
    required int responsePayloadSize,
    required int requestPayloadSize,
    required String responseContentType,
    required String url,
    required String requestBody,
    required String responseBody,
    required String requestHeaders,
    required String responseHeaders,
  }) async {
    try {
      httpMetric.httpResponseCode = httpResponseCode;
      httpMetric.responseContentType = responseContentType;
      httpMetric.responsePayloadSize = responsePayloadSize;
      httpMetric.requestPayloadSize = requestPayloadSize;

      // Optionally, you can add more attributes
      httpMetric.putAttribute('url', url);
      httpMetric.putAttribute('request_body', requestBody);
      httpMetric.putAttribute('response_body', responseBody);
      httpMetric.putAttribute('request_headers', requestHeaders);
      httpMetric.putAttribute('response_headers', responseHeaders);

      await httpMetric.stop();
    } catch (e) {
      _logError('stopHttpMetric', e, additionalInfo: {
        'url': url,
        'responseCode': httpResponseCode.toString(),
        'responseBody': responseBody,
        'requestBody': requestBody,
        'requestHeaders': requestHeaders.toString(),
        'responseHeaders': responseHeaders.toString()
      });
    }
  }

  // Log errors to Crashlytics
  static void _logError(
    String methodName,
    dynamic error, {
    Map<String, String>? additionalInfo,
  }) {
    CrashlyticsService.logError(
      error,
      reason: 'Error in $methodName',
      requestBody: additionalInfo?.toString(),
    );
  }
}
