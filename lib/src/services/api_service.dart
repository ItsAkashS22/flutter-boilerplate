import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_performance/firebase_performance.dart';
import 'analytics_service.dart';
import 'performance_service.dart';
import 'crashlytics_service.dart';
import 'package:flutter_boilerplate/src/core/configuration.dart';
import 'package:flutter_boilerplate/src/core/screen_utils.dart';

class ApiService {
  late String _baseUrl;

  ApiService({String? baseUrl}) {
    _baseUrl = baseUrl ?? Configuration.baseUrl;
  }

  Future<bool> _isConnected() async {
    List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();
    return connectivityResult.first != ConnectivityResult.none;
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    if (!await _isConnected()) {
      throw Exception('No internet connection');
    }
    final url = '$_baseUrl/$endpoint';
    final httpMetric = PerformanceService.startHttpMetric(url, HttpMethod.Get);
    http.Response? response;
    try {
      response = await http.get(Uri.parse(url), headers: headers ?? {});
      await _logApiRequest('GET', endpoint, response);
      return _handleResponse(response, endpoint: endpoint);
    } catch (e, stackTrace) {
      await _logApiError(endpoint, headers, null, e, stackTrace);
      rethrow;
    } finally {
      await _stopHttpMetric(httpMetric, response, url, null, null, headers);
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? jsonData,
    Map<String, String>? headers,
    Map<String, String>? formData,
    Map<String, String>? files,
  }) async {
    if (!await _isConnected()) {
      throw Exception('No internet connection');
    }
    final url = '$_baseUrl/$endpoint';
    final httpMetric = PerformanceService.startHttpMetric(url, HttpMethod.Post);
    http.Response? response;
    try {
      if (jsonData != null) {
        response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json', ...?headers},
          body: json.encode(jsonData),
        );
      } else if (formData != null) {
        var request = http.MultipartRequest('POST', Uri.parse(url))
          ..headers.addAll(headers ?? {})
          ..fields.addAll(formData);
        if (files != null) {
          for (var entry in files.entries) {
            request.files
                .add(await http.MultipartFile.fromPath(entry.key, entry.value));
          }
        }
        response = await http.Response.fromStream(await request.send());
      } else {
        throw Exception('No data provided for POST request');
      }
      await _logApiRequest('POST', endpoint, response);
      return _handleResponse(response, endpoint: endpoint);
    } catch (e, stackTrace) {
      await _logApiError(
          endpoint, headers, jsonData ?? formData, e, stackTrace);
      rethrow;
    } finally {
      await _stopHttpMetric(
          httpMetric, response, url, jsonData, formData, headers);
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? jsonData,
    Map<String, String>? headers,
    Map<String, String>? formData,
    Map<String, String>? files,
  }) async {
    if (!await _isConnected()) {
      throw Exception('No internet connection');
    }
    final url = '$_baseUrl/$endpoint';
    final httpMetric = PerformanceService.startHttpMetric(url, HttpMethod.Put);
    http.Response? response;
    try {
      if (jsonData != null) {
        response = await http.put(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json', ...?headers},
          body: json.encode(jsonData),
        );
      } else if (formData != null) {
        var request = http.MultipartRequest('PUT', Uri.parse(url))
          ..headers.addAll(headers ?? {})
          ..fields.addAll(formData);
        if (files != null) {
          for (var entry in files.entries) {
            request.files
                .add(await http.MultipartFile.fromPath(entry.key, entry.value));
          }
        }
        response = await http.Response.fromStream(await request.send());
      } else {
        throw Exception('No data provided for PUT request');
      }
      await _logApiRequest('PUT', endpoint, response);
      return _handleResponse(response, endpoint: endpoint);
    } catch (e, stackTrace) {
      await _logApiError(
          endpoint, headers, jsonData ?? formData, e, stackTrace);
      rethrow;
    } finally {
      await _stopHttpMetric(
          httpMetric, response, url, jsonData, formData, headers);
    }
  }

  Future<void> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    if (!await _isConnected()) {
      throw Exception('No internet connection');
    }
    final url = '$_baseUrl/$endpoint';
    final httpMetric =
        PerformanceService.startHttpMetric(url, HttpMethod.Delete);
    http.Response? response;
    try {
      response = await http.delete(Uri.parse(url), headers: headers ?? {});
      if (response.statusCode != 200) {
        throw Exception('Failed to delete data: ${response.reasonPhrase}');
      }
      await _logApiRequest('DELETE', endpoint, response);
    } catch (e, stackTrace) {
      await _logApiError(endpoint, headers, null, e, stackTrace);
      rethrow;
    } finally {
      await _stopHttpMetric(httpMetric, response, url, null, null, headers);
    }
  }

  Map<String, dynamic> _handleResponse(
    http.Response response, {
    String? endpoint,
  }) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      CrashlyticsService.logError(
        Exception('Failed to load data'),
        endpoint: endpoint,
        responseBody: response.body,
        reason: response.reasonPhrase,
      );
      throw Exception('Failed to load data: ${response.reasonPhrase}');
    }
  }

  Future<void> _stopHttpMetric(
    HttpMetric httpMetric,
    http.Response? response,
    String url,
    Map<String, dynamic>? jsonData,
    Map<String, String>? formData,
    Map<String, String>? headers,
  ) async {
    await PerformanceService.stopHttpMetric(
      httpMetric: httpMetric,
      httpResponseCode: response?.statusCode ?? 0,
      responsePayloadSize: response?.contentLength ?? 0,
      requestPayloadSize: response?.request?.contentLength ?? 0,
      responseContentType: response?.headers['content-type'] ?? 'Unknown',
      url: url,
      requestBody: jsonData != null
          ? json.encode(jsonData)
          : formData != null
              ? json.encode(formData)
              : '',
      responseBody: response?.body ?? '',
      requestHeaders: json.encode(headers ?? {}),
      responseHeaders: json.encode(response?.headers ?? {}),
    );
  }

  Future<void> _logApiRequest(
    String method,
    String endpoint,
    http.Response response,
  ) async {
    await AnalyticsService.logApiRequest(
      endpoint: endpoint,
      method: method,
      responseCode: response.statusCode,
      responsePayloadSize: response.contentLength ?? 0,
      requestPayloadSize: response.request?.contentLength ?? 0,
      responseContentType: response.headers['content-type'] ?? 'unknown',
    );
  }

  Future<void> _logApiError(
    String endpoint,
    Map<String, String>? headers,
    dynamic requestBody,
    dynamic error,
    StackTrace stackTrace,
  ) async {
    CrashlyticsService.logError(
      error,
      stackTrace: stackTrace,
      endpoint: endpoint,
      requestBody: requestBody != null ? json.encode(requestBody) : null,
      callingPage: ScreenUtils.getCurrentPage(),
    );
  }
}
