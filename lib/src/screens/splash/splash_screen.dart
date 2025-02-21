import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/src/core/screen_utils.dart';
import 'package:flutter_boilerplate/src/screens/home/home_screen.dart';
import 'package:flutter_boilerplate/src/screens/splash/cubit/splash_cubit.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static const String path = "/";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit()..onSplashScreen(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is SplashFinished) {
            context.go(HomeScreen.path);
          }
        },
        child: Scaffold(
          body: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                ScreenUtils.x(4),
              ),
              child: Image.asset(
                'assets/logo.png',
                width: ScreenUtils.width / 3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
