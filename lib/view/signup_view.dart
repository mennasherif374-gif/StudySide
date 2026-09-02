import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_side/view/account_created_view.dart';
import 'package:study_side/view/login_view.dart';
import 'package:study_side/view_model/Auth/auth_bloc.dart';
import 'package:study_side/theme/app_theme.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: BlocConsumer<AuthBloc, AuthState>(
              listenWhen: (previous, current) => !previous.isSuccess && current.isSuccess,
              listener: (context, state) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccountCreatedView(),
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
                      'Create an account',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Join StudySide and start studying with others.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textGrey,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Full Name field
                    TextField(
                      controller: fullNameController,
                      onChanged: (value) {
                        context.read<AuthBloc>().add(AuthFullNameChanged(value));
                      },
                      decoration: const InputDecoration(
                        hintText: 'Full Name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),

                    const SizedBox(height: 16),

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

                    const SizedBox(height: 16),

                    // Password field
                    TextField(
                      controller: passwordController,
                      obscureText: state.obscurePassword,
                      onChanged: (value) {
                        context.read<AuthBloc>().add(AuthPasswordChanged(value));
                      },
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            state.obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textGrey,
                          ),
                          onPressed: () {
                            context.read<AuthBloc>().add(AuthObscurePasswordToggled());
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
                        context.read<AuthBloc>().add(AuthConfirmPasswordChanged(value));
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
                            context.read<AuthBloc>().add(AuthObscureConfirmPasswordToggled());
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
                              context.read<AuthBloc>().add(AuthSignUpSubmitted());
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
                          : const Text('Sign up'),
                    ),

                    const SizedBox(height: 24),

                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          const Text(
                            'Already have an account?  ',
                            style: TextStyle(color: AppColors.textGrey),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginView(),
                                ),
                              );
                            },
                            child: const Text(
                              'Log in',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
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