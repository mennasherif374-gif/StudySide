part of 'auth_bloc.dart';

@immutable

class AuthState {
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final String errorMessage;
  final bool isLoading;
  final bool isSuccess;

  AuthState({
    this.fullName = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.errorMessage = '',
    this.isLoading = false,
    this.isSuccess = false,
  });
}
