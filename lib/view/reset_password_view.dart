import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_side/view/reset_password_success_view.dart';
import 'package:study_side/view_model/ResetPassword/reset_password_bloc.dart';
import 'package:study_side/theme/app_theme.dart';

class ResetPasswordView extends StatefulWidget {

  // This comes from the Firebase reset link (deep link) once that part is wired up
  final String actionCode;

  const ResetPasswordView({super.key, required this.actionCode});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordBloc(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
              listenWhen: (previous, current) => !previous.isSuccess && current.isSuccess,
              listener: (context, state) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ResetPasswordSuccessView(),
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

                    const SizedBox(height: 16),

                    const Text(
                      'Create New Password',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Your new password must be different from your previous password.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textGrey,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // New Password field
                    TextField(
                      controller: newPasswordController,
                      obscureText: state.obscureNewPassword,
                      onChanged: (value) {
                        context.read<ResetPasswordBloc>().add(ResetPasswordNewPasswordChanged(value));
                      },
                      decoration: InputDecoration(
                        hintText: 'New Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            state.obscureNewPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textGrey,
                          ),
                          onPressed: () {
                            context.read<ResetPasswordBloc>().add(ResetPasswordObscureNewPasswordToggled());
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Confirm Password field
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: state.obscureConfirmPassword,
                      onChanged: (value) {
                        context.read<ResetPasswordBloc>().add(ResetPasswordConfirmPasswordChanged(value));
                      },
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            state.obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textGrey,
                          ),
                          onPressed: () {
                            context.read<ResetPasswordBloc>().add(ResetPasswordObscureConfirmPasswordToggled());
                          },
                        ),
                      ),
                    ),

                    if (state.errorMessage.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        state.errorMessage,
                        style: const TextStyle(color: AppColors.error, fontSize: 13),
                      ),
                    ],

                    const SizedBox(height: 28),

                    ElevatedButton(
                      onPressed: state.isLoading
                          ? null
                          : () {
                              context.read<ResetPasswordBloc>().add(
                                    ResetPasswordSubmitted(widget.actionCode),
                                  );
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
                          : const Text('Reset Password'),
                    ),

                    const SizedBox(height: 20),

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