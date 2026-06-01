import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/admin_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/company_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/job_seeker_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/user_model.dart';

class FirebaseService {
  final db = FirebaseFirestore.instance;

  CollectionReference get  users => db.collection('users');
  CollectionReference get  jobSeekers =>  db.collection('job seekers');
  CollectionReference get  companies =>  db.collection('companies');
  CollectionReference get  admins =>  db.collection('admins');

  Future<void> saveUser(UserModel user) =>
       users.doc(user.userID).set(user.toMap());

  Future<UserModel?> getUser(String uid) async {
    final doc = await  users.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) =>
       users.doc(uid).update(data);

  Future<void> deleteUser(String uid) =>  users.doc(uid).delete();

  Future<void> saveJobSeeker(JobSeekerModel js) =>
       jobSeekers.doc(js.userID).set(js.toMap());

  Future<JobSeekerModel?> getJobSeeker(String uid) async {
    final doc = await  jobSeekers.doc(uid).get();
    if (!doc.exists) return null;
    return JobSeekerModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  Future<void> updateJobSeeker(String uid, Map<String, dynamic> data) =>
       jobSeekers.doc(uid).update(data);

  Future<void> saveCompany(CompanyModel company) =>
       companies.doc(company.userID).set(company.toMap());

  Future<CompanyModel?> getCompany(String uid) async {
    final doc = await  companies.doc(uid).get();
    if (!doc.exists) return null;
    return CompanyModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  Future<void> updateCompany(String uid, Map<String, dynamic> data) =>
       companies.doc(uid).update(data);

  Future<void> saveAdmin(AdminModel admin) =>
       admins.doc(admin.userID).set(admin.toMap());

  Future<AdminModel?> getAdmin(String uid) async {
    final doc = await  admins.doc(uid).get();
    if (!doc.exists) return null;
    return AdminModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  Future<void> updateAdmin(String uid, Map<String, dynamic> data) =>
       admins.doc(uid).update(data);
}
