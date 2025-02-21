import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/src/core/configuration.dart';
import 'package:flutter_boilerplate/src/repositories/sample_repository.dart';
import 'package:flutter_boilerplate/src/services/analytics_service.dart';
import 'package:flutter_boilerplate/src/services/api_service.dart';
import 'package:flutter_boilerplate/src/services/crashlytics_service.dart';
import 'package:flutter_boilerplate/src/services/performance_service.dart';
import 'src/app.dart';

FutureOr<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Configuration.initializeConfigurations();
  await Firebase.initializeApp(options: Configuration.firebaseOptions);

  // Services
  await Future.wait([
    CrashlyticsService.initialize(),
    PerformanceService.initialize(),
    AnalyticsService.initialize(),
  ]);
  ApiService apiService = ApiService();

  // Repositories
  SampleRepository sampleRepository = SampleRepository(apiService: apiService);

  // Start Flutter application
  runApp(MyApp(
    sampleRepository: sampleRepository,
  ));
}
