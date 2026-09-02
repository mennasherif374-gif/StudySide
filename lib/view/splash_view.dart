import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_side/view/onboarding_view.dart';

import '../view_model/Splash/splash_bloc.dart';


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
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Image.asset(
                  "assets/images/WhatsApp Image 2026-08-28 at 6.07.44 PM.png",
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 10),

                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Text(
                       'Study',
                       style: TextStyle(
                         fontSize: 30,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                     Text(
                       'Side',
                       style: TextStyle(
                         fontSize: 30,
                         fontWeight: FontWeight.bold,
                         color: Color(0xFF8FA3FF)
                       ),
                     ),
                   ],
                 )
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}