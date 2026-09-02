import 'package:flutter/material.dart';
import 'package:study_side/theme/app_theme.dart';

class PlaceholderView extends StatelessWidget {

  final String title;

  const PlaceholderView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.construction_outlined,
                color: AppColors.primary,
                size: 38,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Coming Soon',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "We're still working on the $title screen.",
              style: const TextStyle(fontSize: 14, color: AppColors.textGrey),
            ),
          ],
        ),
      ),
    );
  }
}