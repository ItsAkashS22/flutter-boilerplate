import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/src/core/global.dart';
import 'package:go_router/go_router.dart';

class ScreenUtils {
  static BuildContext get _context => Global.navKey.currentContext!;

  static double x(int value) => value * 4;

  static double get width => MediaQuery.of(_context).size.width;
  static double get height => MediaQuery.of(_context).size.height;

  static double get statusBarHeight => MediaQuery.of(_context).padding.top;
  static double get bottomBarHeight => MediaQuery.of(_context).padding.bottom;

  static bool get isPortrait =>
      MediaQuery.of(_context).orientation == Orientation.portrait;
  static bool get isLandscape =>
      MediaQuery.of(_context).orientation == Orientation.landscape;

  static double get appBarHeight => AppBar().preferredSize.height;

  static EdgeInsets get screenPadding => MediaQuery.of(_context).padding;
  static EdgeInsets get viewPadding => MediaQuery.of(_context).viewPadding;

  static String getCurrentPage() {
    final context = Global.navKey.currentContext;
    if (context != null) {
      final route =
          GoRouter.of(context).routeInformationProvider.value.uri.toString();
      return route;
    }
    return 'Unknown Page';
  }
}
