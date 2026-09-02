import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_side/view/login_view.dart';
import 'package:study_side/view_model/Auth/auth_bloc.dart';
import 'package:study_side/theme/app_theme.dart';

class CheckYourEmailView extends StatelessWidget {

  final String email;

  const CheckYourEmailView({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc()..add(AuthEmailChanged(email)),
      child: Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: BlocConsumer<AuthBloc, AuthState>(
            listenWhen: (previous, current) => !previous.isSuccess && current.isSuccess,
            listener: (context, state) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Reset email sent again'),
                ),
              );
            },
            builder: (context, state) {
              return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 10),

              // Back arrow
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
              ),

              const SizedBox(height: 12),

              // Circle icon
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.mark_email_read_outlined,
                    color: AppColors.success,
                    size: 34,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Center(
                child: Text(
                  'Check Your Email',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Center(
                child: Text(
                  "We've sent a password reset link to $email",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textGrey,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: () {
                  // TODO: implement opening the device's email app
                },
                child: const Text('Open Email'),
              ),

              const SizedBox(height: 20),

              Center(
                child: Column(
                  children: [
                    const Text(
                      "Didn't receive the email?",
                      style: TextStyle(color: AppColors.textGrey),
                    ),
                    TextButton(
                      onPressed: state.isLoading
                          ? null
                          : () {
                              context.read<AuthBloc>().add(AuthForgotPasswordSubmitted());
                            },
                      child: const Text('Resend Email'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginView(),
                      ),
                    );
                  },
                  child: const Text(
                    'Back to Sign In',
                    style: TextStyle(
                      color: AppColors.textGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              ],
              );
            },
          ),
        ),
      ),
      ),
    );
  }
}