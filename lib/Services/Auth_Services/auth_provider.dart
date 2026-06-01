import 'package:elevate_app/Data_Model_Classes/Firebase_Models/admin_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/company_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/job_seeker_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/user_model.dart';
import 'package:elevate_app/Services/Firebase_Services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_services.dart';
import '../Firebase_Services/firebase_provider.dart';

final authService = AuthService();
final firebaseService = FirebaseService();

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(authService, firebaseService);
});

class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final UserModel? user;

  const AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    UserModel? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
      user: user ?? this.user,
    );
  }

  AuthState clearMessages() {
    return AuthState(isLoading: isLoading, user: user);
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService auth;
  final FirebaseService db;

  AuthNotifier(this.auth, this.db) : super(const AuthState());

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    required String userType,
  }) async {
    try {
      final firebaseUser = await auth.signUp(email: email, password: password);
      if (firebaseUser == null) throw Exception('Sign up failed');

      final userModel = UserModel(
        userID: firebaseUser.uid,
        name: name,
        password: password,
        email: email,
        userType: userType,
      );
      await db.saveUser(userModel);

      if (userType == 'JobSeeker') {
        await db.saveJobSeeker(JobSeekerModel(userID: firebaseUser.uid));
      } else if (userType == 'Company') {
        await db.saveCompany(CompanyModel(userID: firebaseUser.uid));
      } else if (userType == 'Admin') {
        await db.saveAdmin(AdminModel(userID: firebaseUser.uid));
      }

      await auth.sendEmailVerification();
      state = state.copyWith(user: userModel);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      state = state.copyWith(isLoading: true);
      await auth.login(email: email, password: password);
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Logged in successfully.',
      );
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: readableError(e.code),
      );
      return false;
    }
  }

  Future<void> logout() async {
    await auth.logout();
    state = const AuthState();
  }

  Future<bool> forgotPassword(String email) async {
    try {
      state = state.copyWith(isLoading: true);
      await auth.sendPasswordResetEmail(email: email);
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Password reset email sent.',
      );
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: readableError(e.code),
      );
      return false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      await auth.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      if (state.user != null) {
        await db.updateUser(state.user!.userID, {'password': newPassword});
      }
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Password changed successfully.',
      );
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: readableError(e.code),
      );
      return false;
    }
  }

  String readableError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'No internet connection.';
      case 'requires-recent-login':
        return 'Please log out and log back in first.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
