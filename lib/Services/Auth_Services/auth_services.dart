import 'package:firebase_auth/firebase_auth.dart';

// Stream<User?> get authStateChanges => _auth.authStateChanges(); replaced : final user = ref.watch(authProvider).user;
class AuthService {
  // Connects to Firebase Authentication.
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Returns the currently logged-in user.
  User? get currentUser => auth.currentUser;

  // Checks if current user's email is verified.
  bool get isEmailVerified => auth.currentUser?.emailVerified ?? false;

  // Creates a new Firebase account.
  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    final credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  // Checks if email/password are correct. If the email is not verified: Exception is thrown
  Future<User?> login({required String email, required String password}) async {
    final credential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    // ?  if user comes back null for any reason, the ! version will crash the app while the ?. version will just skip the check safely.
    if (credential.user?.emailVerified == false) {
      throw Exception('Verify your email first');
    }

    return credential.user;
  }

  // Logging out
  Future<void> logout() async {
    await auth.signOut();
  }

  // Sending password reset email
  Future<void> sendPasswordResetEmail({required String email}) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  // Sending email verification
  Future<void> sendEmailVerification() async {
    await auth.currentUser?.sendEmailVerification();
  }

  // Changing the password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = auth.currentUser;
    if (user == null || user.email == null) {
      throw Exception('No user logged in');
    }

    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  }

  Future<void> deleteAccount({required String currentPassword}) async {
    final user = auth.currentUser;
    if (user == null || user.email == null) {
      throw Exception('No user logged in');
    }

    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(credential);
    await user.delete();
  }
}
