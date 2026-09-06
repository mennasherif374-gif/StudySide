import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_side/view/auth/onboarding_view.dart';
import 'package:study_side/theme/app_theme.dart';

import '../../view_model/Splash/splash_bloc.dart';


class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc()..add(SplashStarted()),

      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashFinished) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const OnboardingView(),
              ),
            );
          }
        },

        child: Scaffold(
          backgroundColor: AppColors.primary,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Image.asset(
                    "assets/images/WhatsApp Image 2026-08-28 at 6.07.44 PM.png",
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Study',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Side',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD8DFFF),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                const Text(
                  'Focus better, together',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 40),

                const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}