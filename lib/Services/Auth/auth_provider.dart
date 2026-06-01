import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:elevate_app/Data_Model_Classes/Firebase_Models/user_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/job_seeker_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/company_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/admin_model.dart';

import 'auth_service.dart';
import 'firebase_service.dart';

final authProvider = StateNotifierProvider<AuthNotifier, UserModel?>((ref) {
  return AuthNotifier(AuthService(), FirebaseService());
});

final db = FirebaseService();

final jobSeekerProvider = FutureProvider<JobSeekerModel?>((ref) {
  final uid = ref.watch(authProvider)?.userID;
  if (uid == null) return Future.value(null);
  return db.getJobSeeker(uid);
});

final companyProvider = FutureProvider<CompanyModel?>((ref) {
  final uid = ref.watch(authProvider)?.userID;
  if (uid == null) return Future.value(null);
  return db.getCompany(uid);
});

final adminProvider = FutureProvider<AdminModel?>((ref) {
  final uid = ref.watch(authProvider)?.userID;
  if (uid == null) return Future.value(null);
  return db.getAdmin(uid);
});

class AuthNotifier extends StateNotifier<UserModel?> {
  final AuthService auth;
  final FirebaseService db;

  AuthNotifier(this.auth, this.db) : super(null);

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    required String userType,
  }) async {
    try {
      final firebaseUser = await auth.signUp(email: email, password: password);
      if (firebaseUser == null) return false;

      final user = UserModel(
        userID: firebaseUser.uid,
        name: name,
        email: email,
        password: password,
        userType: userType,
      );

      await db.saveUser(user);

      if (userType == 'JobSeeker') {
        await db.saveJobSeeker(JobSeekerModel(userID: user.userID));
      } else if (userType == 'Company') {
        await db.saveCompany(CompanyModel(userID: user.userID));
      } else if (userType == 'Admin') {
        await db.saveAdmin(AdminModel(userID: user.userID));
      }

      state = user;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await auth.login(email: email, password: password);

      await loadCurrentUser();

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> logout() async {
    await auth.logout();
    state = null;
  }

  Future<void> forgotPassword(String email) async {
    await auth.forgotPassword(email: email);
  }

  Future<void> loadCurrentUser() async {
    final firebaseUser = auth.currentUser;
    if (firebaseUser == null) return;
    state = await db.getUser(firebaseUser.uid);
  }

  Future<void> resendVerificationEmail() async {
    await auth.currentUser?.sendEmailVerification();
  }
}
