import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_side/view/auth/check_your_email_view.dart';
import 'package:study_side/view_model/Auth/auth_bloc.dart';
import 'package:study_side/theme/app_theme.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: BlocConsumer<AuthBloc, AuthState>(
              listenWhen: (previous, current) => !previous.isSuccess && current.isSuccess,
              listener: (context, state) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckYourEmailView(
                      email: state.email,
                    ),
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
                          color: AppColors.primaryLight.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.mark_email_read_outlined,
                          color: AppColors.primary,
                          size: 34,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Center(
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Center(
                      child: Text(
                        "Don't worry! Enter your email and we'll help you reset your password.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textGrey,
                          height: 1.4,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Email field
                    TextField(
                      controller: emailController,
                      onChanged: (value) {
                        context.read<AuthBloc>().add(AuthEmailChanged(value));
                      },
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),

                    if (state.errorMessage.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        state.errorMessage,
                        style: const TextStyle(color: AppColors.error, fontSize: 13),
                      ),
                    ],

                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: state.isLoading
                          ? null
                          : () {
                              context.read<AuthBloc>().add(AuthForgotPasswordSubmitted());
                            },
                      child: state.isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Send Reset Link'),
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