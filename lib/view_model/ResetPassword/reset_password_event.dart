part of 'reset_password_bloc.dart';

@immutable

abstract class ResetPasswordEvent {}

class ResetPasswordNewPasswordChanged extends ResetPasswordEvent {
  final String newPassword;
  ResetPasswordNewPasswordChanged(this.newPassword);
}

class ResetPasswordConfirmPasswordChanged extends ResetPasswordEvent {
  final String confirmPassword;
  ResetPasswordConfirmPasswordChanged(this.confirmPassword);
}

class ResetPasswordObscureNewPasswordToggled extends ResetPasswordEvent {}

class ResetPasswordObscureConfirmPasswordToggled extends ResetPasswordEvent {}

// The action code comes from the Firebase reset link (deep link), not from a TextField
class ResetPasswordSubmitted extends ResetPasswordEvent {
  final String actionCode;
  ResetPasswordSubmitted(this.actionCode);
}
