import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:study_side/firebase/auth/firebase_auth_service.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {

  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();

  ResetPasswordBloc() : super(ResetPasswordState()) {

    on<ResetPasswordNewPasswordChanged>((event, emit) {
      emit(ResetPasswordState(
        newPassword: event.newPassword,
        confirmPassword: state.confirmPassword,
        obscureNewPassword: state.obscureNewPassword,
        obscureConfirmPassword: state.obscureConfirmPassword,
        errorMessage: '',
        isLoading: false,
        isSuccess: false,
      ));
    });

    on<ResetPasswordConfirmPasswordChanged>((event, emit) {
      emit(ResetPasswordState(
        newPassword: state.newPassword,
        confirmPassword: event.confirmPassword,
        obscureNewPassword: state.obscureNewPassword,
        obscureConfirmPassword: state.obscureConfirmPassword,
        errorMessage: '',
        isLoading: false,
        isSuccess: false,
      ));
    });

    on<ResetPasswordObscureNewPasswordToggled>((event, emit) {
      emit(ResetPasswordState(
        newPassword: state.newPassword,
        confirmPassword: state.confirmPassword,
        obscureNewPassword: !state.obscureNewPassword,
        obscureConfirmPassword: state.obscureConfirmPassword,
        errorMessage: state.errorMessage,
        isLoading: state.isLoading,
        isSuccess: state.isSuccess,
      ));
    });

    on<ResetPasswordObscureConfirmPasswordToggled>((event, emit) {
      emit(ResetPasswordState(
        newPassword: state.newPassword,
        confirmPassword: state.confirmPassword,
        obscureNewPassword: state.obscureNewPassword,
        obscureConfirmPassword: !state.obscureConfirmPassword,
        errorMessage: state.errorMessage,
        isLoading: state.isLoading,
        isSuccess: state.isSuccess,
      ));
    });

    on<ResetPasswordSubmitted>((event, emit) async {

      // Check new password is not empty
      if (state.newPassword.isEmpty) {
        emit(ResetPasswordState(
          newPassword: state.newPassword,
          confirmPassword: state.confirmPassword,
          obscureNewPassword: state.obscureNewPassword,
          obscureConfirmPassword: state.obscureConfirmPassword,
          errorMessage: 'Password is required',
          isLoading: false,
          isSuccess: false,
        ));
        return;
      }

      // Check new password length
      if (state.newPassword.length < 6) {
        emit(ResetPasswordState(
          newPassword: state.newPassword,
          confirmPassword: state.confirmPassword,
          obscureNewPassword: state.obscureNewPassword,
          obscureConfirmPassword: state.obscureConfirmPassword,
          errorMessage: 'Password must be at least 6 characters',
          isLoading: false,
          isSuccess: false,
        ));
        return;
      }

      // Check confirm password is not empty
      if (state.confirmPassword.isEmpty) {
        emit(ResetPasswordState(
          newPassword: state.newPassword,
          confirmPassword: state.confirmPassword,
          obscureNewPassword: state.obscureNewPassword,
          obscureConfirmPassword: state.obscureConfirmPassword,
          errorMessage: 'Please confirm your password',
          isLoading: false,
          isSuccess: false,
        ));
        return;
      }

      // Check password and confirm password match
      if (state.newPassword != state.confirmPassword) {
        emit(ResetPasswordState(
          newPassword: state.newPassword,
          confirmPassword: state.confirmPassword,
          obscureNewPassword: state.obscureNewPassword,
          obscureConfirmPassword: state.obscureConfirmPassword,
          errorMessage: 'Passwords do not match',
          isLoading: false,
          isSuccess: false,
        ));
        return;
      }

      // Show loading while Firebase confirms the new password
      emit(ResetPasswordState(
        newPassword: state.newPassword,
        confirmPassword: state.confirmPassword,
        obscureNewPassword: state.obscureNewPassword,
        obscureConfirmPassword: state.obscureConfirmPassword,
        errorMessage: '',
        isLoading: true,
        isSuccess: false,
      ));

      try {
        await firebaseAuthService.confirmPasswordReset(
          code: event.actionCode,
          newPassword: state.newPassword,
        );

        emit(ResetPasswordState(
          newPassword: state.newPassword,
          confirmPassword: state.confirmPassword,
          obscureNewPassword: state.obscureNewPassword,
          obscureConfirmPassword: state.obscureConfirmPassword,
          errorMessage: '',
          isLoading: false,
          isSuccess: true,
        ));

      } on FirebaseAuthException catch (e) {

        String message = 'Something went wrong. Please try again';

        if (e.code == 'invalid-action-code') {
          message = 'This reset link is invalid or has already been used';
        } else if (e.code == 'expired-action-code') {
          message = 'This reset link has expired';
        } else if (e.code == 'weak-password') {
          message = 'This password is too weak';
        }

        emit(ResetPasswordState(
          newPassword: state.newPassword,
          confirmPassword: state.confirmPassword,
          obscureNewPassword: state.obscureNewPassword,
          obscureConfirmPassword: state.obscureConfirmPassword,
          errorMessage: message,
          isLoading: false,
          isSuccess: false,
        ));
      }
    });
  }
}
