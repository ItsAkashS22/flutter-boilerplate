import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/src/core/global.dart';
import 'package:go_router/go_router.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.dimension = 32,
  });

  final double dimension;

  static void show() {
    showDialog(
      context: Global.navKey.currentContext!,
      barrierDismissible: false,
      builder: (context) => temp(),
    );
  }

  static PopScope<dynamic> temp() {
    return const PopScope(
      canPop: false,
      child: Center(
        child: Card(
          shape: CircleBorder(),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: LoadingIndicator(),
          ),
        ),
      ),
    );
  }

  static void close() => Global.navKey.currentContext?.pop();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: dimension,
      height: dimension,
      child: CircularProgressIndicator.adaptive(
        strokeWidth: 4,
        valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
        strokeCap: StrokeCap.round,
      ),
    );
  }
}
