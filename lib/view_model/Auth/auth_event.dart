part of 'auth_bloc.dart';

@immutable

abstract class AuthEvent {}

class AuthFullNameChanged extends AuthEvent {
  final String fullName;
  AuthFullNameChanged(this.fullName);
}

class AuthEmailChanged extends AuthEvent {
  final String email;
  AuthEmailChanged(this.email);
}

class AuthPasswordChanged extends AuthEvent {
  final String password;
  AuthPasswordChanged(this.password);
}

class AuthConfirmPasswordChanged extends AuthEvent {
  final String confirmPassword;
  AuthConfirmPasswordChanged(this.confirmPassword);
}

class AuthObscurePasswordToggled extends AuthEvent {}

class AuthObscureConfirmPasswordToggled extends AuthEvent {}

class AuthSignUpSubmitted extends AuthEvent {}

class AuthSignInSubmitted extends AuthEvent {}

class AuthForgotPasswordSubmitted extends AuthEvent {}

class AuthLogoutRequested extends AuthEvent {}
