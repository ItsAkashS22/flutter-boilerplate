import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/src/core/configuration.dart';
import 'package:flutter_boilerplate/src/screens/home/bloc/home_bloc.dart';
import 'package:flutter_boilerplate/src/screens/sample/sample_screen.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String path = "/home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          Configuration.flavor.name.toUpperCase(),
          style: TextStyle(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      ),
      body: ListView(
        children: [
          actionTile(
            onTap: () {
              context.read<HomeBloc>().add(GetSuccessEvent());
            },
            title: "GET Request - Success",
            subtitle: "Perform a successful GET network call",
          ),
          actionTile(
            onTap: () {
              context.read<HomeBloc>().add(PostSuccessEvent());
            },
            title: "POST Request - Success",
            subtitle: "Perform a successful POST network call",
          ),
          actionTile(
            onTap: () {
              context.read<HomeBloc>().add(GetErrorEvent());
            },
            title: "GET Request - Error",
            subtitle: "Perform a error producing GET network call",
          ),
          actionTile(
            onTap: () {
              context.read<HomeBloc>().add(PostErrorEvent());
            },
            title: "POST Request - Error",
            subtitle: "Perform a error producing POST network call",
          ),
          actionTile(
            onTap: () {
              context.push(SampleScreen.path);
            },
            title: "Navigate",
            subtitle: "Crash the app to test Crashlytics",
          ),
          actionTile(
            onTap: () {
              FirebaseCrashlytics.instance.crash();
            },
            title: "Crash",
            subtitle: "Crash the app to test Crashlytics",
          ),
        ],
      ),
    );
  }

  ListTile actionTile({
    required void Function()? onTap,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      onTap: onTap,
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(
        Icons.keyboard_arrow_right_rounded,
      ),
    );
  }
}
