// This service allows the admin to create a JobSeeker account
// without logging out of the admin account.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AdminService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> createJobSeeker({
    required String name,
    required String email,
    required String password,
  }) async {
    FirebaseApp app;
    try {
      app = Firebase.app("SecondaryApp");
    } catch (_) {
      app = await Firebase.initializeApp(
        name: "SecondaryApp",
        options: Firebase.app().options,
      );
    }
    FirebaseAuth auth = FirebaseAuth.instanceFor(app: app);
    UserCredential user = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    String uid = user.user!.uid;

    await db.collection('jobSeekers').doc(uid).set({
      'jobSeekerID': uid,
      'name': name,
      'email': email,
      'password': password,
      'profilePic': '',
      'userType': 'JobSeeker',
    });

    await auth.signOut();
    return uid;
  }

  Future<String> createCompany({
    required String companyName,
    required String email,
    required String password,
  }) async {
    FirebaseApp app;
    try {
      app = Firebase.app("SecondaryApp");
    } catch (_) {
      app = await Firebase.initializeApp(
        name: "SecondaryApp",
        options: Firebase.app().options,
      );
    }
    FirebaseAuth auth = FirebaseAuth.instanceFor(app: app);
    UserCredential user = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    String uid = user.user!.uid;

    await db.collection('companies').doc(uid).set({
      'companyID': uid,
      'companyName': companyName,
      'email': email,
      'password': password,
      'logo': '',
      'userType': 'Company',
    });

    await auth.signOut();
    return uid;
  }
}
