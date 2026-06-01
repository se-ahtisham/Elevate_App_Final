/*import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  User? get currentUser => auth.currentUser;
  Stream<User?> get authStateChanges => auth.authStateChanges();
  bool get isEmailVerified => auth.currentUser?.emailVerified ?? false;

  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    final result = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await result.user?.sendEmailVerification();
    return result.user;
  }

  Future<User?> login({required String email, required String password}) async {
    final result = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  Future<void> logout() => auth.signOut();

  Future<void> sendPasswordResetEmail({required String email}) =>
      auth.sendPasswordResetEmail(email: email);

  Future<void> reloadUser() async => await auth.currentUser?.reload();

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _requireUser();
    await _reauthenticate(user, currentPassword);
    await user.updatePassword(newPassword);
  }

  Future<void> updateEmail({
    required String currentPassword,
    required String newEmail,
  }) async {
    final user = _requireUser();
    await _reauthenticate(user, currentPassword);
    await user.verifyBeforeUpdateEmail(newEmail);
  }

  Future<void> deleteAccount({required String currentPassword}) async {
    final user = _requireUser();
    await _reauthenticate(user, currentPassword);
    await user.delete();
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  User _requireUser() {
    final user = auth.currentUser;
    if (user == null || user.email == null) {
      throw Exception('No user logged in');
    }

    return user;
  }

  Future<void> _reauthenticate(User user, String password) async {
    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );
    await user.reauthenticateWithCredential(credential);
  }
}
*/

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  User? get currentUser => auth.currentUser;

  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    final result = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await result.user?.sendEmailVerification();

    return result.user;
  }

  Future<User?> login({required String email, required String password}) async {
    final result = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    await result.user?.reload();

    if (!(result.user?.emailVerified ?? false)) {
      await auth.signOut();
      throw Exception("EMAIL_NOT_VERIFIED");
    }

    return result.user;
  }

  Future<void> logout() async {
    await auth.signOut();
  }


Future<void> resendVerificationEmail() async {
  await auth.currentUser?.sendEmailVerification();
}
  Future<void> forgotPassword({required String email}) async {
    await auth.sendPasswordResetEmail(email: email);
  }
}
