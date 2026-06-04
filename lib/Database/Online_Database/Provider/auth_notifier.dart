import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/admin_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_seeker_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/user_model.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_state.dart';

final fireauth = FirebaseAuth.instance;
// ignore: non_constant_identifier_names
final db_firebaseservice = FirebaseService();

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    required String userType,
  }) async {
    state = state.clearMessages().copyWith(isLoading: true);
    try {
      final result = await fireauth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = result.user!.uid;
      await result.user!.sendEmailVerification();

      final user = UserModel(
        userID: uid,
        name: name,
        email: email,
        password: password,
        userType: userType,
      );
      await db_firebaseservice.saveUser(user);

      if (userType == 'JobSeeker') {
        await db_firebaseservice.saveJobSeeker(JobSeekerModel(userID: uid));
      } else if (userType == 'Company') {
        await db_firebaseservice.saveCompany(CompanyModel(userID: uid));
      } else if (userType == 'Admin') {
        await db_firebaseservice.saveAdmin(AdminModel(userID: uid));
      }

      state = state.copyWith(
        isLoading: false,
        user: user,
        successMessage: 'Account created! Please verify your email.',
      );
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message ?? 'Sign up failed.',
      );
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.clearMessages().copyWith(isLoading: true);
    try {
      final result = await fireauth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await result.user!.reload();
      if (!result.user!.emailVerified) {
        await fireauth.signOut();
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Please verify your email before logging in.',
        );
        return false;
      }
      final user = await db_firebaseservice.getUser(result.user!.uid);
      state = state.copyWith(
        isLoading: false,
        user: user,
        successMessage: 'Welcome back!',
      );
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message ?? 'Login failed.',
      );
      return false;
    }
  }

  Future<void> logout() async {
    await fireauth.signOut();
    state = const AuthState();
  }

  Future<bool> forgotPassword(String email) async {
    state = state.clearMessages().copyWith(isLoading: true);
    try {
      await fireauth.sendPasswordResetEmail(email: email);
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Password reset email sent.',
      );
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message ?? 'Could not send reset email.',
      );
      return false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = state.clearMessages().copyWith(isLoading: true);
    try {
      final user = requireUser();
      await reauth(user, currentPassword);
      await user.updatePassword(newPassword);
      if (state.user != null) {
        await db_firebaseservice.updateUser(state.user!.userID, {
          'password': newPassword,
        });
      }
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Password updated.',
      );
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message ?? 'Could not update password.',
      );
      return false;
    }
  }

  Future<bool> updateEmail({
    required String currentPassword,
    required String newEmail,
  }) async {
    state = state.clearMessages().copyWith(isLoading: true);
    try {
      final user = requireUser();
      await reauth(user, currentPassword);
      await user.verifyBeforeUpdateEmail(newEmail);
      if (state.user != null) {
        await db_firebaseservice.updateUser(state.user!.userID, {
          'email': newEmail,
        });
      }
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Verification sent to $newEmail.',
      );
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message ?? 'Could not update email.',
      );
      return false;
    }
  }

  Future<bool> deleteAccount(String currentPassword) async {
    state = state.clearMessages().copyWith(isLoading: true);
    try {
      final user = requireUser();
      await reauth(user, currentPassword);
      await user.delete();
      state = const AuthState();
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message ?? 'Could not delete account.',
      );
      return false;
    }
  }

  Future<void> loadCurrentUser() async {
    final current = fireauth.currentUser;
    if (current == null) return;
    final user = await db_firebaseservice.getUser(current.uid);
    if (user != null) state = state.copyWith(user: user);
  }

Future<void> resendVerificationEmail(String email, String password) async {
  try {
    final result = await fireauth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await result.user!.sendEmailVerification();
    await fireauth.signOut();
  } on FirebaseAuthException catch (e) {
    state = state.copyWith(errorMessage: e.message ?? 'Could not resend email.');
  }
}

  void clearMessages() => state = state.clearMessages();

  User requireUser() {
    final u = fireauth.currentUser;
    if (u == null || u.email == null) {
      throw FirebaseAuthException(code: 'no-current-user');
    }
    return u;
  }

  Future<void> reauth(User user, String password) async {
    await user.reauthenticateWithCredential(
      EmailAuthProvider.credential(email: user.email!, password: password),
    );
  }
}
