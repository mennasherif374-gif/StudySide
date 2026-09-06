// lib/firebase/auth/firebase_auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Create a new account with email and password
  Future<User?> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    UserCredential result = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Save the full name on the Firebase user profile
    await result.user?.updateDisplayName(displayName);
    await result.user?.reload();

    return firebaseAuth.currentUser;
  }

  // Sign in with an existing email and password
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Make sure the display name is loaded, same as signUp does.
    await firebaseAuth.currentUser?.reload();

    return firebaseAuth.currentUser;
  }

  // Sign out the current user
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  // Send a password reset email
  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // Confirm the new password using the action code from the reset link
  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) async {
    await firebaseAuth.confirmPasswordReset(
      code: code,
      newPassword: newPassword,
    );
  }
}