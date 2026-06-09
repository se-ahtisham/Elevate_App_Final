import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/admin_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_seeker_model.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_notifier.dart';
import 'auth_state.dart';

final db = FirebaseService();

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (_) => AuthNotifier(),
);

final jobSeekerProvider = FutureProvider<JobSeekerModel?>((ref) {
  final uid = ref.watch(authProvider).user?.userID;
  return uid == null ? Future.value(null) : db.getJobSeeker(uid);
});

final companyProvider = FutureProvider<CompanyModel?>((ref) {
  final uid = ref.watch(authProvider).user?.userID;
  return uid == null ? Future.value(null) : db.getCompany(uid);
});

final adminProvider = FutureProvider<AdminModel?>((ref) {
  final uid = ref.watch(authProvider).user?.userID;
  return uid == null ? Future.value(null) : db.getAdmin(uid);
});
