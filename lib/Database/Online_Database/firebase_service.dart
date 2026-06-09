import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/admin_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/education_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_experience_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_seeker_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/user_model.dart';

class FirebaseService {
  // ignore: non_constant_identifier_names
  final db_firebaseservice = FirebaseFirestore.instance;

  // Users
  Future<void> saveUser(UserModel u) =>
      db_firebaseservice.collection('users').doc(u.userID).set(u.toMap());

  Future<UserModel?> getUser(String id) async {
    final doc = await db_firebaseservice.collection('users').doc(id).get();
    return doc.exists ? UserModel.fromMap(doc.data()!) : null;
  }

  Future<void> updateUser(String id, Map<String, dynamic> data) =>
      db_firebaseservice.collection('users').doc(id).update(data);

  // Job Seekers
  Future<void> saveJobSeeker(JobSeekerModel js) => db_firebaseservice
      .collection('jobSeekers')
      .doc(js.userID)
      .set(js.toMap());

  Future<JobSeekerModel?> getJobSeeker(String id) async {
    final doc = await db_firebaseservice.collection('jobSeekers').doc(id).get();
    return doc.exists ? JobSeekerModel.fromMap(doc.data()!) : null;
  }

  Future<void> updateJobSeeker(String id, Map<String, dynamic> data) =>
      db_firebaseservice.collection('jobSeekers').doc(id).update(data);

  Future<void> updateEducationList(
    String uid,
    List<EducationModel> education,
  ) => db_firebaseservice.collection('jobSeekers').doc(uid).update({
    'education': education.map((e) => e.toMap()).toList(),
  });
  Future<void> updateJobExperienceList(
    String uid,
    List<JobExperienceModel> jobExperience,
  ) => db_firebaseservice.collection('jobSeekers').doc(uid).update({
    'jobExperience': jobExperience.map((e) => e.toMap()).toList(),
  });

  // Companies
  Future<void> saveCompany(CompanyModel c) =>
      db_firebaseservice.collection('companies').doc(c.userID).set(c.toMap());

  Future<CompanyModel?> getCompany(String id) async {
    final doc = await db_firebaseservice.collection('companies').doc(id).get();
    return doc.exists ? CompanyModel.fromMap(doc.data()!) : null;
  }

  // Admin
  Future<void> saveAdmin(AdminModel a) =>
      db_firebaseservice.collection('admins').doc(a.userID).set(a.toMap());

  Future<AdminModel?> getAdmin(String id) async {
    final doc = await db_firebaseservice.collection('admins').doc(id).get();
    return doc.exists ? AdminModel.fromMap(doc.data()!) : null;
  }
}
