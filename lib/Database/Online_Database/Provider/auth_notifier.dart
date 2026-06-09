import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/admin_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/education_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_experience_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_seeker_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/user_model.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_state.dart';

final fireauth = FirebaseAuth.instance;
final db_firebaseservice = FirebaseService();

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  //  SIGN UP
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

  //  LOGIN
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

  //  LOGOUT
  Future<void> logout() async {
    await fireauth.signOut();
    state = const AuthState();
  }

  //  FORGOT PASSWORD
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

  //  CHANGE PASSWORD
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

  //  UPDATE EMAIL
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

  //  DELETE ACCOUNT
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

  //  LOAD CURRENT USER

  Future<void> loadCurrentUser() async {
    final current = fireauth.currentUser;
    if (current == null) return;
    final user = await db_firebaseservice.getUser(current.uid);
    if (user != null) state = state.copyWith(user: user);
  }

  //  RESEND VERIFICATION EMAIL
  Future<void> resendVerificationEmail(String email, String password) async {
    try {
      final result = await fireauth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await result.user!.sendEmailVerification();
      await fireauth.signOut();
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        errorMessage: e.message ?? 'Could not resend email.',
      );
    }
  }

Future<bool> updateProfile({
  required String name,
  required String shortDescription,
  required String experienceLevel,
  required List<EducationModel> educations,
  required List<JobExperienceModel> experiences,
}) async {
  if (state.user == null) return false;
  state = state.clearMessages().copyWith(isLoading: true);
  try {
    final uid = state.user!.userID;

    await db_firebaseservice.updateUser(uid, {'name': name.trim()});

    await db_firebaseservice.updateJobSeeker(uid, {
      'shortDescription': shortDescription.trim(),
      'experienceLevel': experienceLevel.trim(),
    });

    await db_firebaseservice.updateEducationList(uid, educations);
    await db_firebaseservice.updateJobExperienceList(uid, experiences);

    state = state.copyWith(
      isLoading: false,
      successMessage: 'Profile updated.',
    );
    return true;
  } on FirebaseException catch (e) {
    state = state.copyWith(
      isLoading: false,
      errorMessage: e.message ?? 'Update failed.',
    );
    return false;
  }
}


  

  Future<bool> addEducation(EducationModel edu) async {
    if (state.user == null) return false;
    state = state.clearMessages().copyWith(isLoading: true);
    try {
      final uid = state.user!.userID;
      final js = await db_firebaseservice.getJobSeeker(uid);
      if (js == null) return false;
      await db_firebaseservice.updateEducationList(uid, [...js.education, edu]);
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Education added.',
      );
      return true;
    } on FirebaseException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message ?? 'Could not add education.',
      );
      return false;
    }
  }

  Future<bool> updateEducation(int index, EducationModel edu) async {
    if (state.user == null) return false;
    state = state.clearMessages().copyWith(isLoading: true);
    try {
      final uid = state.user!.userID;
      final js = await db_firebaseservice.getJobSeeker(uid);
      if (js == null) return false;
      final updated = List<EducationModel>.from(js.education)..[index] = edu;
      await db_firebaseservice.updateEducationList(uid, updated);
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Education updated.',
      );
      return true;
    } on FirebaseException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message ?? 'Could not update education.',
      );
      return false;
    }
  }

  Future<bool> deleteEducation(int index) async {
    if (state.user == null) return false;
    state = state.clearMessages().copyWith(isLoading: true);
    try {
      final uid = state.user!.userID;
      final js = await db_firebaseservice.getJobSeeker(uid);
      if (js == null) return false;
      final updated = List<EducationModel>.from(js.education)..removeAt(index);
      await db_firebaseservice.updateEducationList(uid, updated);
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Education removed.',
      );
      return true;
    } on FirebaseException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message ?? 'Could not delete education.',
      );
      return false;
    }
  }

  Future<bool> addJobExperience(JobExperienceModel exp) async {
    if (state.user == null) return false;
    state = state.clearMessages().copyWith(isLoading: true);
    try {
      final uid = state.user!.userID;
      final js = await db_firebaseservice.getJobSeeker(uid);
      if (js == null) return false;
      await db_firebaseservice.updateJobExperienceList(uid, [
        ...js.jobExperience,
        exp,
      ]);
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Experience added.',
      );
      return true;
    } on FirebaseException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message ?? 'Could not add experience.',
      );
      return false;
    }
  }

  Future<bool> updateJobExperience(int index, JobExperienceModel exp) async {
    if (state.user == null) return false;
    state = state.clearMessages().copyWith(isLoading: true);
    try {
      final uid = state.user!.userID;
      final js = await db_firebaseservice.getJobSeeker(uid);
      if (js == null) return false;
      final updated = List<JobExperienceModel>.from(js.jobExperience)
        ..[index] = exp;
      await db_firebaseservice.updateJobExperienceList(uid, updated);
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Experience updated.',
      );
      return true;
    } on FirebaseException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message ?? 'Could not update experience.',
      );
      return false;
    }
  }

  Future<bool> deleteJobExperience(int index) async {
    if (state.user == null) return false;
    state = state.clearMessages().copyWith(isLoading: true);
    try {
      final uid = state.user!.userID;
      final js = await db_firebaseservice.getJobSeeker(uid);
      if (js == null) return false;
      final updated = List<JobExperienceModel>.from(js.jobExperience)
        ..removeAt(index);
      await db_firebaseservice.updateJobExperienceList(uid, updated);
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Experience removed.',
      );
      return true;
    } on FirebaseException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message ?? 'Could not delete experience.',
      );
      return false;
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
