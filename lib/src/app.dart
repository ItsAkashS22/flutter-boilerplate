// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_boilerplate/src/core/routes.dart';
import 'package:flutter_boilerplate/src/core/theme.dart';
import 'package:flutter_boilerplate/src/repositories/sample_repository.dart';
import 'package:flutter_boilerplate/src/screens/home/bloc/home_bloc.dart';

class MyApp extends StatelessWidget {
  final SampleRepository sampleRepository;

  const MyApp({
    super.key,
    required this.sampleRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => sampleRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeBloc(sampleRepository: sampleRepository),
          ),
        ],
        child: ListenableBuilder(
          listenable: Listenable.merge([
            AppTheme(),
            // --- Any more Listenable can be addeds
          ]),
          builder: (context, child) => child!,
          child: MaterialApp.router(
            title: "Flutter Boilerplate",
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: AppTheme().themeMode,
            routerConfig: AppRoute.routes,
          ),
        ),
      ),
    );
  }
}
