// This service allows the admin to create a JobSeeker/Company account
// without logging out of the admin account. Uses a secondary Firebase app
// instance so the admin session is preserved.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AdminService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  /// Returns an isolated secondary FirebaseApp, creating it if needed.
  Future<FirebaseApp> _getSecondaryApp() async {
    try {
      return Firebase.app("SecondaryApp");
    } catch (_) {
      return Firebase.initializeApp(
        name: "SecondaryApp",
        options: Firebase.app().options,
      );
    }
  }

  Future<String> createJobSeeker({
    required String name,
    required String email,
    required String password,
  }) async {
    final app = await _getSecondaryApp();
    final auth = FirebaseAuth.instanceFor(app: app);
    try {
      // Create Authentication account
      final user = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = user.user!.uid;

      // Save JobSeeker data
      await db.collection('jobSeekers').doc(uid).set({
        'jobSeekerID': uid,
        'name': name,
        'email': email,
        'password': password,
      });

      await auth.signOut();
      await app.delete();
      return uid;
    } catch (e) {
      try {
        await auth.signOut();
      } catch (_) {}
      try {
        await app.delete();
      } catch (_) {}
      rethrow;
    }
  }

  Future<String> createCompany({
    required String companyName,
    required String email,
    required String password,
  }) async {
    final app = await _getSecondaryApp();
    final auth = FirebaseAuth.instanceFor(app: app);
    try {
      // Create Authentication account
      final user = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = user.user!.uid;

      // Save Company data
      await db.collection('companies').doc(uid).set({
        'companyID': uid,
        'companyName': companyName,
        'email': email,
        'password': password,
      });

      await auth.signOut();
      await app.delete();
      return uid;
    } catch (e) {
      try {
        await auth.signOut();
      } catch (_) {}
      try {
        await app.delete();
      } catch (_) {}
      rethrow;
    }
  }
}
