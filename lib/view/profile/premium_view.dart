import 'package:flutter/material.dart';
import 'package:study_side/theme/app_theme.dart';

// Shown when the user taps "Upgrade Now" on the Profile screen.
// There is no real payment system yet - this just shows what Premium
// includes, matching the task's "no real payment gateway" requirement.
class PremiumView extends StatelessWidget {
  const PremiumView({super.key});

  static const _features = [
    'Unlimited study rooms',
    'Advanced progress analytics',
    'Custom focus & break timers',
    'No ads, ever',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StudySide Premium')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.workspace_premium,
                  color: Colors.white,
                  size: 32,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'Unlock Premium',
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: 8),

              const Text(
                'Get the most out of your study sessions.',
                style: TextStyle(fontSize: 14, color: AppColors.textGrey),
              ),

              const SizedBox(height: 24),

              for (final feature in _features) _FeatureRow(text: feature),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Payments are not available yet'),
                      ),
                    );
                  },
                  child: const Text('Upgrade Now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String text;

  const _FeatureRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.success, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.color,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
