import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/admin_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/education_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_experience_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_seeker_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/user_index_model.dart';
import 'package:elevate_app/Database/Online_Database/auth_service.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Lets other parts of the app listen for login/logout from Firebase directly.
final authStateProvider = StreamProvider<User?>((ref) {
  return AuthService().authStateChanges;
});

// The main provider our screens will use.
final authProvider = ChangeNotifierProvider<AuthNotifier>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends ChangeNotifier {
  final AuthService authService = AuthService();
  final FirebaseService firebaseService = FirebaseService();

  // These are the values the UI will read and react to.
  bool isLoading = false;
  String? errorMessage;
  String? successMessage;
  String? userType; // "JobSeeker", "Company", or "Admin"
  JobSeekerModel? jobSeeker;
  CompanyModel? company;
  AdminModel? admin;

  // Sign up a new user.
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    required String userType,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    User? user;
    try {
      user = await authService.signUp(email, password);

      if (user == null) {
        errorMessage = 'Signup failed. Try again.';
        isLoading = false;
        notifyListeners();
        return false;
      }

      // Everything below can fail independently of auth creation.
      try {
        final index = UserIndexModel(
          userID: user.uid,
          email: email,
          userType: userType,
        );
        await firebaseService.saveUserIndex(index);

        if (userType == 'JobSeeker') {
          final newJobSeeker = JobSeekerModel(
            jobSeekerID: user.uid,
            name: name,
            email: email,
            password: password,
          );
          await firebaseService.saveJobSeeker(newJobSeeker);
          jobSeeker = newJobSeeker;
        } else if (userType == 'Company') {
          final newCompany = CompanyModel(
            companyID: user.uid,
            email: email,
            companyName: name,
            password: password,
          );
          await firebaseService.saveCompany(newCompany);
          company = newCompany;
        } else if (userType == 'Admin') {
          final newAdmin = AdminModel(
            adminID: user.uid,
            name: name,
            email: email,
            password: password,
          );
          await firebaseService.saveAdmin(newAdmin);
          admin = newAdmin;
        }
      } catch (writeError) {
        try {
          await user.delete();
        } catch (_) {}
        rethrow;
      }

      this.userType = userType;
      try {
        await authService.sendEmailVerification();
        successMessage = 'Account created! Please verify your email.';
      } catch (_) {
        successMessage =
            'Account created! We couldn\'t send the verification email — '
            'you can resend it from your profile.';
      }

      isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = formatAuthError(e);
      isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = 'Something went wrong. Please try again.';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Log an existing user in.
  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
      final user = await authService.login(email, password);

      if (user == null) {
        errorMessage = 'Login failed. Try again.';
        isLoading = false;
        notifyListeners();
        return false;
      }

      await user.reload(); // refresh emailVerified in case it's stale
      if (!user.emailVerified) {
        await authService.logout();
        errorMessage = 'Please verify your email before logging in.';
        isLoading = false;
        notifyListeners();
        return false;
      }

      final index = await firebaseService.getUserIndex(user.uid);

      if (index == null) {
        await authService.logout();
        errorMessage = 'Account record not found.';
        isLoading = false;
        notifyListeners();
        return false;
      }

      userType = index.userType;

      if (userType == 'JobSeeker') {
        jobSeeker = await firebaseService.getJobSeeker(user.uid);
      } else if (userType == 'Company') {
        company = await firebaseService.getCompany(user.uid);
      } else if (userType == 'Admin') {
        admin = await firebaseService.getAdmin(user.uid);
      }

      successMessage = 'Welcome back!';
      isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = formatAuthError(e);
      isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = 'Something went wrong. Please try again.';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Log the current user out and clear everything.
  Future<void> logout() async {
    await authService.logout();
    isLoading = false;
    errorMessage = null;
    successMessage = null;
    userType = null;
    jobSeeker = null;
    company = null;
    admin = null;
    notifyListeners();
  }

  // Send a password reset email.
  Future<bool> forgotPassword(String email) async {
    isLoading = true;
      errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
      await authService.sendPasswordResetEmail(email);
      successMessage = 'Password reset email sent. Check your inbox.';
      isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = formatAuthError(e);
      isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = 'Something went wrong. Please try again.';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Change the logged-in user's password.
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
      await authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      successMessage = 'Password updated successfully.';
      isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = formatAuthError(e);
      isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = 'Something went wrong. Please try again.';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteAccount(String currentPassword) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final uid = authService.currentUser?.uid;
      final type = userType;
      if (uid == null || type == null) {
        errorMessage = 'No user is logged in.';
        isLoading = false;
        notifyListeners();
        return false;
      }

      // Verify password + delete the login FIRST.
      await authService.deleteAccount(currentPassword);
      // Only clean up Firestore data once we know the password was correct.
      await firebaseService.deleteUserCompletely(uid, type);

      userType = null;
      jobSeeker = null;
      company = null;
      admin = null;
      isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = formatAuthError(e);
      isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = 'Something went wrong. Please try again.';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateFullProfile({
    required String name,
    required String location,
    required String about,
    required String experienceLevel,
    required List<EducationModel> educations,
    required List<JobExperienceModel> experiences,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final uid = authService.currentUser?.uid;
      if (uid == null) {
        errorMessage = 'No user is logged in.';
        isLoading = false;
        notifyListeners();
        return false;
      }

      final newData = {
        'name': name,
        'location': location,
        'about': about,
        'experienceLevel': experienceLevel,
        'education': educations.map((e) => e.toMap()).toList(),
        'jobExperience': experiences.map((e) => e.toMap()).toList(),
      };

      await firebaseService.updateJobSeeker(uid, newData);
      jobSeeker = await firebaseService.getJobSeeker(uid);

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = 'Could not update profile. Please try again.';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> resendVerificationEmail(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      if (authService.currentUser == null) {
        await authService.login(email, password);
      }
      await authService.sendEmailVerification();
      isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = formatAuthError(e);
      isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = 'Could not resend verification email.';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Change the logged-in user's email.
  Future<bool> updateEmail({
    required String currentPassword,
    required String newEmail,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
      await authService.updateEmail(
        currentPassword: currentPassword,
        newEmail: newEmail,
      );
      successMessage =
          'Verification sent to $newEmail. Click the link to confirm.';
      isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = formatAuthError(e);
      isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = 'Something went wrong. Please try again.';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Called on app startup to check if someone is already logged in.
  Future<void> loadCurrentUser() async {
    final currentUser = authService.currentUser;
    if (currentUser == null) return;

    final index = await firebaseService.getUserIndex(currentUser.uid);
    if (index == null) {
      await authService.logout();
      return;
    }

    userType = index.userType;

    if (userType == 'JobSeeker') {
      jobSeeker = await firebaseService.getJobSeeker(currentUser.uid);
    } else if (userType == 'Company') {
      company = await firebaseService.getCompany(currentUser.uid);
    } else if (userType == 'Admin') {
      admin = await firebaseService.getAdmin(currentUser.uid);
    }

    notifyListeners();
  }

  // Clear any error/success message (e.g. after showing a SnackBar).
  void clearMessages() {
    errorMessage = null;
    successMessage = null;
    notifyListeners();
  }

  // Maps Firebase auth errors to human-readable ones.
  String formatAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-credential':
      case 'wrong-password':
        return 'Incorrect email or password. Please try again.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'email-already-in-use':
        return 'This email is already in use by another account.';
      case 'weak-password':
        return 'The password is too weak. Please use a stronger password.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later.';
      default:
        return e.message ?? 'Something went wrong. Please try again.';
    }
  }
}
