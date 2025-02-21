import 'package:flutter_boilerplate/src/core/constants.dart';
import 'package:flutter_boilerplate/src/services/api_service.dart';

class SampleRepository {
  final ApiService _apiService;

  SampleRepository({required ApiService apiService}) : _apiService = apiService;

  Future<void> getSuccess() async {
    try {
      await _apiService.get(Constants.successEP);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getError() async {
    try {
      await _apiService.get(Constants.errorEP);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postSuccess() async {
    try {
      await _apiService.post(
        Constants.postSuccessEP,
        jsonData: {
          'title': 'foo',
          'body': 'bar',
          'userId': 1,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postError() async {
    try {
      await _apiService.post(
        Constants.errorEP,
        jsonData: {
          'title': 'foo',
          'body': 'bar',
          'userId': 1,
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
