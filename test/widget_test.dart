// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/src/app.dart';
import 'package:flutter_boilerplate/src/core/configuration.dart';
import 'package:flutter_boilerplate/src/repositories/sample_repository.dart';
import 'package:flutter_boilerplate/src/services/analytics_service.dart';
import 'package:flutter_boilerplate/src/services/api_service.dart';
import 'package:flutter_boilerplate/src/services/crashlytics_service.dart';
import 'package:flutter_boilerplate/src/services/performance_service.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> main() async {
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

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      sampleRepository: sampleRepository,
    ));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
