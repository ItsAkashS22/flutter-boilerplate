import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/src/core/global.dart';
import 'package:flutter_boilerplate/src/screens/home/home_screen.dart';
import 'package:flutter_boilerplate/src/screens/sample/sample_screen.dart';
import 'package:flutter_boilerplate/src/screens/splash/splash_screen.dart';
import 'package:flutter_boilerplate/src/services/analytics_service.dart';
import 'package:go_router/go_router.dart';

class AppRoute {
  static final GoRouter routes = GoRouter(
    navigatorKey: Global.navKey,
    observers: [
      AnalyticsService.observer,
    ],
    routes: [
      GoRoute(
        path: SplashScreen.path,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: HomeScreen.path,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: SampleScreen.path,
        builder: (context, state) => const SampleScreen(),
      ),
    ],
    // TODO: common error widget
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: Text("data"),
      ),
      body: Text("data"),
    ),
  );
}
