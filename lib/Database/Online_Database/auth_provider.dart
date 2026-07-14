import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/admin_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/education_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_experience_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_seeker_model.dart';
import 'package:elevate_app/Database/Online_Database/admin_service.dart';
import 'package:elevate_app/Database/Online_Database/auth_service.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return AuthService().authStateChanges;
});

final authProvider = ChangeNotifierProvider<AuthNotifier>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends ChangeNotifier {
  final AuthService authService = AuthService();
  final FirebaseService firebaseService = FirebaseService();
  final AdminService adminService = AdminService();

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;
  String? userType; // "JobSeeker", "Company", or "Admin"
  JobSeekerModel? jobSeeker;
  CompanyModel? company;
  AdminModel? admin;

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

      try {
        if (userType == 'JobSeeker') {
          jobSeeker = JobSeekerModel(
            jobSeekerID: user.uid,
            name: name,
            email: email,
            password: password,
          );
          await firebaseService.saveJobSeeker(jobSeeker!);
        } else if (userType == 'Company') {
          company = CompanyModel(
            companyID: user.uid,
            email: email,
            companyName: name,
            password: password,
          );
          await firebaseService.saveCompany(company!);
        } else if (userType == 'Admin') {
          admin = AdminModel(
            adminID: user.uid,
            name: name,
            email: email,
            password: password,
          );
          await firebaseService.saveAdmin(admin!);
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
            "Account created! We couldn't send the verification email — "
            'you can resend it from your profile.';
      }

      isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already in use by another account.';
          break;
        case 'weak-password':
          errorMessage =
              'The password is too weak. Please use a stronger password.';
          break;
        case 'invalid-email':
          errorMessage = 'Please enter a valid email address.';
          break;
        default:
          errorMessage = e.message ?? 'Something went wrong. Please try again.';
      }
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

      await user.reload();
      if (!user.emailVerified) {
        await authService.logout();
        errorMessage = 'Please verify your email before logging in.';
        isLoading = false;
        notifyListeners();
        return false;
      }

      // Check which collection this uid belongs to instead of userIndex.
      jobSeeker = await firebaseService.getJobSeeker(user.uid);
      if (jobSeeker != null) {
        userType = 'JobSeeker';
      } else {
        company = await firebaseService.getCompany(user.uid);
        if (company != null) {
          userType = 'Company';
        } else {
          admin = await firebaseService.getAdmin(user.uid);
          if (admin != null) {
            userType = 'Admin';
          } else {
            await authService.logout();
            errorMessage = 'Account record not found.';
            isLoading = false;
            notifyListeners();
            return false;
          }
        }
      }

      successMessage = 'Welcome back!';
      isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
        case 'wrong-password':
          errorMessage = 'Incorrect email or password. Please try again.';
          break;
        case 'user-not-found':
          errorMessage = 'No account found with this email.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many login attempts. Please try again later.';
          break;
        default:
          errorMessage = e.message ?? 'Something went wrong. Please try again.';
      }
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
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No account found with this email.';
          break;
        case 'invalid-email':
          errorMessage = 'Please enter a valid email address.';
          break;
        default:
          errorMessage = e.message ?? 'Something went wrong. Please try again.';
      }
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
      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          errorMessage = 'Incorrect current password.';
          break;
        case 'weak-password':
          errorMessage =
              'The password is too weak. Please use a stronger password.';
          break;
        default:
          errorMessage = e.message ?? 'Something went wrong. Please try again.';
      }
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

      await authService.deleteAccount(currentPassword);
      await firebaseService.deleteUserCompletely(uid, type);

      userType = null;
      jobSeeker = null;
      company = null;
      admin = null;
      isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          errorMessage = 'Incorrect password.';
          break;
        default:
          errorMessage = e.message ?? 'Something went wrong. Please try again.';
      }
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

      await firebaseService.updateJobSeeker(uid, {
        'name': name,
        'location': location,
        'about': about,
        'experienceLevel': experienceLevel,
        'education': educations.map((e) => e.toMap()).toList(),
        'jobExperience': experiences.map((e) => e.toMap()).toList(),
      });
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
      errorMessage = e.message ?? 'Something went wrong. Please try again.';
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
      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          errorMessage = 'Incorrect password.';
          break;
        case 'email-already-in-use':
          errorMessage = 'This email is already in use by another account.';
          break;
        case 'invalid-email':
          errorMessage = 'Please enter a valid email address.';
          break;
        default:
          errorMessage = e.message ?? 'Something went wrong. Please try again.';
      }
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

  Future<void> loadCurrentUser() async {
    final currentUser = authService.currentUser;
    if (currentUser == null) return;

    jobSeeker = await firebaseService.getJobSeeker(currentUser.uid);
    if (jobSeeker != null) {
      userType = 'JobSeeker';
    } else {
      company = await firebaseService.getCompany(currentUser.uid);
      if (company != null) {
        userType = 'Company';
      } else {
        admin = await firebaseService.getAdmin(currentUser.uid);
        if (admin != null) {
          userType = 'Admin';
        } else {
          await authService.logout();
          return;
        }
      }
    }
    notifyListeners();
  }

  // Used by an admin to add a new JobSeeker account without logging
  // themselves out. Wraps AdminService.createJobSeeker.
  Future<bool> addJobSeekerByAdmin({
    required String name,
    required String email,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
      await adminService.createJobSeeker(
        name: name,
        email: email,
        password: password,
      );
      successMessage = 'Account created successfully.';
      isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already in use by another account.';
          break;
        case 'weak-password':
          errorMessage =
              'The password is too weak. Please use a stronger password.';
          break;
        case 'invalid-email':
          errorMessage = 'Please enter a valid email address.';
          break;
        default:
          errorMessage = e.message ?? 'Something went wrong. Please try again.';
      }
      isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
