import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:study_side/firebase/auth/firebase_auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();

  AuthBloc() : super(AuthState()) {

    on<AuthFullNameChanged>((event, emit) {
      emit(AuthState(
        fullName: event.fullName,
        email: state.email,
        password: state.password,
        confirmPassword: state.confirmPassword,
        obscurePassword: state.obscurePassword,
        obscureConfirmPassword: state.obscureConfirmPassword,
        errorMessage: '',
        isLoading: false,
        isSuccess: false,
      ));
    });

    on<AuthEmailChanged>((event, emit) {
      emit(AuthState(
        fullName: state.fullName,
        email: event.email,
        password: state.password,
        confirmPassword: state.confirmPassword,
        obscurePassword: state.obscurePassword,
        obscureConfirmPassword: state.obscureConfirmPassword,
        errorMessage: '',
        isLoading: false,
        isSuccess: false,
      ));
    });

    on<AuthPasswordChanged>((event, emit) {
      emit(AuthState(
        fullName: state.fullName,
        email: state.email,
        password: event.password,
        confirmPassword: state.confirmPassword,
        obscurePassword: state.obscurePassword,
        obscureConfirmPassword: state.obscureConfirmPassword,
        errorMessage: '',
        isLoading: false,
        isSuccess: false,
      ));
    });

    on<AuthConfirmPasswordChanged>((event, emit) {
      emit(AuthState(
        fullName: state.fullName,
        email: state.email,
        password: state.password,
        confirmPassword: event.confirmPassword,
        obscurePassword: state.obscurePassword,
        obscureConfirmPassword: state.obscureConfirmPassword,
        errorMessage: '',
        isLoading: false,
        isSuccess: false,
      ));
    });

    on<AuthObscurePasswordToggled>((event, emit) {
      emit(AuthState(
        fullName: state.fullName,
        email: state.email,
        password: state.password,
        confirmPassword: state.confirmPassword,
        obscurePassword: !state.obscurePassword,
        obscureConfirmPassword: state.obscureConfirmPassword,
        errorMessage: state.errorMessage,
        isLoading: state.isLoading,
        isSuccess: state.isSuccess,
      ));
    });

    on<AuthObscureConfirmPasswordToggled>((event, emit) {
      emit(AuthState(
        fullName: state.fullName,
        email: state.email,
        password: state.password,
        confirmPassword: state.confirmPassword,
        obscurePassword: state.obscurePassword,
        obscureConfirmPassword: !state.obscureConfirmPassword,
        errorMessage: state.errorMessage,
        isLoading: state.isLoading,
        isSuccess: state.isSuccess,
      ));
    });

    on<AuthSignUpSubmitted>((event, emit) async {

      // Check full name is not empty
      if (state.fullName.isEmpty) {
        emit(AuthState(
          fullName: state.fullName,
          email: state.email,
          password: state.password,
          confirmPassword: state.confirmPassword,
          obscurePassword: state.obscurePassword,
          obscureConfirmPassword: state.obscureConfirmPassword,
          errorMessage: 'Name is required',
          isLoading: false,
          isSuccess: false,
        ));
        return;
      }

      // Check email is not empty
      if (state.email.isEmpty) {
        emit(AuthState(
          fullName: state.fullName,
          email: state.email,
          password: state.password,
          confirmPassword: state.confirmPassword,
          obscurePassword: state.obscurePassword,
          obscureConfirmPassword: state.obscureConfirmPassword,
          errorMessage: 'Email is required',
          isLoading: false,
          isSuccess: false,
        ));
        return;
      }

      // Check email format
      final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
      if (!emailPattern.hasMatch(state.email)) {
        emit(AuthState(
          fullName: state.fullName,
          email: state.email,
          password: state.password,
          confirmPassword: state.confirmPassword,
          obscurePassword: state.obscurePassword,
          obscureConfirmPassword: state.obscureConfirmPassword,
          errorMessage: 'Please enter a valid email',
          isLoading: false,
          isSuccess: false,
        ));
        return;
      }

      // Check password is not empty
      if (state.password.isEmpty) {
        emit(AuthState(
          fullName: state.fullName,
          email: state.email,
          password: state.password,
          confirmPassword: state.confirmPassword,
          obscurePassword: state.obscurePassword,
          obscureConfirmPassword: state.obscureConfirmPassword,
          errorMessage: 'Password is required',
          isLoading: false,
          isSuccess: false,
        ));
        return;
      }

      // Check password length
      if (state.password.length < 6) {
        emit(AuthState(
          fullName: state.fullName,
          email: state.email,
          password: state.password,
          confirmPassword: state.confirmPassword,
          obscurePassword: state.obscurePassword,
          obscureConfirmPassword: state.obscureConfirmPassword,
          errorMessage: 'Password must be at least 6 characters',
          isLoading: false,
          isSuccess: false,
        ));
        return;
      }

      // Check confirm password is not empty
      if (state.confirmPassword.isEmpty) {
        emit(AuthState(
          fullName: state.fullName,
          email: state.email,
          password: state.password,
          confirmPassword: state.confirmPassword,
          obscurePassword: state.obscurePassword,
          obscureConfirmPassword: state.obscureConfirmPassword,
          errorMessage: 'Please confirm your password',
          isLoading: false,
          isSuccess: false,
        ));
        return;
      }

      // Check password and confirm password match
      if (state.password != state.confirmPassword) {
        emit(AuthState(
          fullName: state.fullName,
          email: state.email,
          password: state.password,
          confirmPassword: state.confirmPassword,
          obscurePassword: state.obscurePassword,
          obscureConfirmPassword: state.obscureConfirmPassword,
          errorMessage: 'Passwords do not match',
          isLoading: false,
          isSuccess: false,
        ));
        return;
      }

      // Show loading while Firebase is creating the account
      emit(AuthState(
        fullName: state.fullName,
        email: state.email,
        password: state.password,
        confirmPassword: state.confirmPassword,
        obscurePassword: state.obscurePassword,
        obscureConfirmPassword: state.obscureConfirmPassword,
        errorMessage: '',
        isLoading: true,
        isSuccess: false,
      ));

      try {
        await firebaseAuthService.signUp(
          email: state.email,
          password: state.password,
        );

        emit(AuthState(
          fullName: state.fullName,
          email: state.email,
          password: state.password,
          confirmPassword: state.confirmPassword,
          obscurePassword: state.obscurePassword,
          obscureConfirmPassword: state.obscureConfirmPassword,
          errorMessage: '',
          isLoading: false,
          isSuccess: true,
        ));

      } on FirebaseAuthException catch (e) {
        print(e.code);

        String message = 'DEBUG CODE: ${e.code}';

        if (e.code == 'email-already-in-use') {
          message = 'This email is already in use';
        } else if (e.code == 'invalid-email') {
          message = 'Please enter a valid email';
        } else if (e.code == 'weak-password') {
          message = 'This password is too weak';
        }

        emit(AuthState(
          fullName: state.fullName,
          email: state.email,
          password: state.password,
          confirmPassword: state.confirmPassword,
          obscurePassword: state.obscurePassword,
          obscureConfirmPassword: state.obscureConfirmPassword,
          errorMessage: message,
          isLoading: false,
          isSuccess: false,
        ));
      }
    });

    on<AuthSignInSubmitted>((event, emit) async {

      // Check email is not empty
      if (state.email.isEmpty) {
        emit(AuthState(
          email: state.email,
          password: state.password,
          obscurePassword: state.obscurePassword,
          errorMessage: 'Email is required',
          isLoading: false,
          isSuccess: false,
        ));
        return;
      }

      // Check email format
      final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
      if (!emailPattern.hasMatch(state.email)) {
        emit(AuthState(
          email: state.email,
          password: state.password,
          obscurePassword: state.obscurePassword,
          errorMessage: 'Please enter a valid email',
          isLoading: false,
          isSuccess: false,
        ));
        return;
      }

      // Check password is not empty
      if (state.password.isEmpty) {
        emit(AuthState(
          email: state.email,
          password: state.password,
          obscurePassword: state.obscurePassword,
          errorMessage: 'Password is required',
          isLoading: false,
          isSuccess: false,
        ));
        return;
      }

      // Check password length
      if (state.password.length < 6) {
        emit(AuthState(
          email: state.email,
          password: state.password,
          obscurePassword: state.obscurePassword,
          errorMessage: 'Password must be at least 6 characters',
          isLoading: false,
          isSuccess: false,
        ));
        return;
      }

      // Show loading while Firebase is signing the user in
      emit(AuthState(
        email: state.email,
        password: state.password,
        obscurePassword: state.obscurePassword,
        errorMessage: '',
        isLoading: true,
        isSuccess: false,
      ));

      try {
        await firebaseAuthService.signIn(
          email: state.email,
          password: state.password,
        );

        emit(AuthState(
          email: state.email,
          password: state.password,
          obscurePassword: state.obscurePassword,
          errorMessage: '',
          isLoading: false,
          isSuccess: true,
        ));

      } on FirebaseAuthException catch (e) {

        String message = 'Something went wrong. Please try again';

        if (e.code == 'user-not-found') {
          message = 'No account found with this email';
        } else if (e.code == 'wrong-password') {
          message = 'Wrong password';
        } else if (e.code == 'invalid-email') {
          message = 'Please enter a valid email';
        } else if (e.code == 'invalid-credential') {
          message = 'Email or password is incorrect';
        }

        emit(AuthState(
          email: state.email,
          password: state.password,
          obscurePassword: state.obscurePassword,
          errorMessage: message,
          isLoading: false,
          isSuccess: false,
        ));
      }
    });

    on<AuthForgotPasswordSubmitted>((event, emit) async {

      // Check email is not empty
      if (state.email.isEmpty) {
        emit(AuthState(
          email: state.email,
          errorMessage: 'Email is required',
          isLoading: false,
          isSuccess: false,
        ));
        return;
      }

      // Check email format
      final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
      if (!emailPattern.hasMatch(state.email)) {
        emit(AuthState(
          email: state.email,
          errorMessage: 'Please enter a valid email',
          isLoading: false,
          isSuccess: false,
        ));
        return;
      }

      // Show loading while Firebase is sending the reset email
      emit(AuthState(
        email: state.email,
        errorMessage: '',
        isLoading: true,
        isSuccess: false,
      ));

      try {
        await firebaseAuthService.sendPasswordResetEmail(
          email: state.email,
        );

        emit(AuthState(
          email: state.email,
          errorMessage: '',
          isLoading: false,
          isSuccess: true,
        ));

      } on FirebaseAuthException catch (e) {

        String message = 'Something went wrong. Please try again';

        if (e.code == 'user-not-found') {
          message = 'No account found with this email';
        } else if (e.code == 'invalid-email') {
          message = 'Please enter a valid email';
        }

        emit(AuthState(
          email: state.email,
          errorMessage: message,
          isLoading: false,
          isSuccess: false,
        ));
      }
    });

    on<AuthLogoutRequested>((event, emit) async {
      emit(AuthState(isLoading: true));

      try {
        await firebaseAuthService.signOut();

        emit(AuthState(isLoading: false, isSuccess: true));

      } catch (e) {
        emit(AuthState(
          isLoading: false,
          errorMessage: 'Something went wrong. Please try again',
        ));
      }
    });
  }
}
