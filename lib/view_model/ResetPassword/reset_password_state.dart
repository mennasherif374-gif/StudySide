part of 'reset_password_bloc.dart';

@immutable

class ResetPasswordState {
  final String newPassword;
  final String confirmPassword;
  final bool obscureNewPassword;
  final bool obscureConfirmPassword;
  final String errorMessage;
  final bool isLoading;
  final bool isSuccess;

  ResetPasswordState({
    this.newPassword = '',
    this.confirmPassword = '',
    this.obscureNewPassword = true,
    this.obscureConfirmPassword = true,
    this.errorMessage = '',
    this.isLoading = false,
    this.isSuccess = false,
  });
}
