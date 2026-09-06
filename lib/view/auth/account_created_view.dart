import 'package:flutter/material.dart';
import 'package:study_side/view/home/home_view.dart';
import 'package:study_side/theme/app_theme.dart';

class AccountCreatedView extends StatelessWidget {
  const AccountCreatedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Image.asset(
                'assets/images/account_created_illustration.jpg',
                width: 220,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 28),

              const Text(
                'Welcome to StudySide!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "Your account has been created successfully. Let's start your focus journey together!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textGrey,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 36),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeView()),
                  );
                },
                child: const Text('Start Studying'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}