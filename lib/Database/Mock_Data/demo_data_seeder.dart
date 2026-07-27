import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/admin_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_seeker_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_post_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/application_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/post_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/comment_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/test_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/question_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/result_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/education_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_experience_model.dart';

class DemoDataSeeder {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> seedAllData() async {
    debugPrint("Clearing old demo data first...");
    await clearDemoData();

    debugPrint("Starting data seeding...");

    // Store UIDs for referencing
    String adminId = '';
    List<String> companyIds = [];
    List<String> jobSeekerIds = [];

    // 1. Admin
    adminId = await _createUser("admin@test.com", "Test@123");
    if (adminId.isNotEmpty) {
      final admin = AdminModel(
        adminID: adminId,
        name: "Super Admin",
        email: "admin@test.com",
        password: "Test@123",
        userType: "Admin",
        about: "System Administrator",
        location: "HQ",
        profilePic: "https://ui-avatars.com/api/?name=Admin",
      );
      await _firestore.collection('admins').doc(adminId).set(admin.toMap());
    }

    // 2. Companies
    final List<Map<String, String>> companyData = [
      {
        "email": "company1@test.com",
        "name": "TechCorp Innovations",
        "industry": "Software Development",
        "logo": "https://ui-avatars.com/api/?name=TC"
      },
      {
        "email": "company2@test.com",
        "name": "Creative Studio",
        "industry": "Design & UI/UX",
        "logo": "https://ui-avatars.com/api/?name=CS"
      },
      {
        "email": "company3@test.com",
        "name": "NextGen Logistics",
        "industry": "Supply Chain",
        "logo": "https://ui-avatars.com/api/?name=NL"
      },
    ];

    for (var cData in companyData) {
      String uid = await _createUser(cData["email"]!, "Test@123");
      if (uid.isNotEmpty) {
        companyIds.add(uid);
        final company = CompanyModel(
          companyID: uid,
          email: cData["email"]!,
          password: "Test@123",
          userType: "Company",
          securityQuestion: "What is your pet's name?",
          securityAnswer: "Fluffy",
          companyName: cData["name"]!,
          industry: cData["industry"]!,
          website: "https://www.example.com",
          logo: cData["logo"]!,
          description: "Leading company in ${cData["industry"]}.",
          location: "New York, USA",
          companySize: 100,
          activeJobs: 0,
          followersCount: 0,
          followers: [],
          followRequests: [],
          employeeList: [],
          companyWeaknessList: [],
          companyStrengthList: [],
          achievementList: ["Top Employer 2024", "Innovation Award"],
          receivedApplications: [],
          postedJobs: [],
        );
        await _firestore.collection('companies').doc(uid).set(company.toMap());
      }
    }

    // 3. Job Seekers
    final List<Map<String, String>> seekerData = [
      {"email": "seeker1@test.com", "name": "Alice Developer", "level": "Mid"},
      {"email": "seeker2@test.com", "name": "Bob Designer", "level": "Senior"},
      {"email": "seeker3@test.com", "name": "Charlie PM", "level": "Junior"},
      {"email": "seeker4@test.com", "name": "Diana Engineer", "level": "Mid"},
      {"email": "seeker5@test.com", "name": "Evan Analyst", "level": "Senior"},
      {"email": "seeker6@test.com", "name": "Fiona Tester", "level": "Junior"},
    ];

    for (var sData in seekerData) {
      String uid = await _createUser(sData["email"]!, "Test@123");
      if (uid.isNotEmpty) {
        jobSeekerIds.add(uid);
        final seeker = JobSeekerModel(
          jobSeekerID: uid,
          name: sData["name"]!,
          email: sData["email"]!,
          password: "Test@123",
          userType: "JobSeeker",
          profilePic: "https://ui-avatars.com/api/?name=${sData["name"]![0]}",
          location: "San Francisco, USA",
          about: "Enthusiastic professional looking for opportunities.",
          shortDescription: "Software Engineer",
          experienceLevel: sData["level"]!,
          skillCount: 3,
          following: [],
          followers: [],
          followRequests: [],
          followedCompanies: [],
          postList: [],
          portfolio: [],
          totalTestsTaken: 0,
          appliedJobRequests: [],
          becomeEmployee: [],
          careerGuidanceTasks: [],
          earnedBadges: [],
          totalBadgesEarned: 0,
          education: [
            EducationModel(year: "2020", title: "BSc Computer Science", school: "State University")
          ],
          jobExperience: [
            JobExperienceModel(jobTitle: "Intern", company: "Some Startup", from: "2021", to: "2022")
          ],
        );
        await _firestore.collection('jobSeekers').doc(uid).set(seeker.toMap());
      }
    }

    if (companyIds.isEmpty || jobSeekerIds.isEmpty) {
      debugPrint("Failed to create users, skipping rest of seeding.");
      return;
    }

    // 4. Job Posts
    List<String> jobPostIds = [];
    for (String compId in companyIds) {
      for (int i = 0; i < 3; i++) {
        final jobRef = _firestore.collection('job_posts').doc();
        jobPostIds.add(jobRef.id);
        final jobPost = JobPostModel(
          jobID: jobRef.id,
          companyID: compId,
          title: "Role ${i + 1} at Company",
          description: "We are looking for talented people for this amazing role.",
          requiredSkills: ["Flutter", "Dart", "Firebase"],
          requiredBadges: [],
          salary: "\$80,000 - \$120,000",
          jobType: "Full-time",
          location: "Remote",
          experienceLevel: i == 0 ? "Junior" : "Mid",
          postedAt: DateTime.now().subtract(Duration(days: i)),
          applicants: [],
          isExternal: false,
          sourceUrl: '',
          isClosed: false,
        );
        await jobRef.set(jobPost.toMap());
        
        // update company active jobs count
        await _firestore.collection('companies').doc(compId).update({
          'activeJobs': FieldValue.increment(1),
          'postedJobs': FieldValue.arrayUnion([jobRef.id])
        });
      }
    }

    // 5. Applications (Seekers applying to Jobs)
    for (int i = 0; i < jobSeekerIds.length; i++) {
      String seekerId = jobSeekerIds[i];
      // Apply to 2 random jobs
      for (int j = 0; j < 2; j++) {
        String jobId = jobPostIds[(i + j) % jobPostIds.length];
        // Fetch job to get companyId
        final jobDoc = await _firestore.collection('job_posts').doc(jobId).get();
        if (jobDoc.exists) {
          String compId = jobDoc.data()!['companyID'];
          
          final appRef = _firestore.collection('applications').doc();
          final app = ApplicationModel(
            applicationID: appRef.id,
            jobID: jobId,
            jobSeekerID: seekerId,
            companyID: compId,
            status: "Pending",
            appliedAt: DateTime.now(),
            coldEmail: "I am very interested in this role and believe I am a great fit.",
            resumeUrl: "",
          );
          await appRef.set(app.toMap());
          
          await _firestore.collection('job_posts').doc(jobId).update({
            'applicants': FieldValue.arrayUnion([appRef.id])
          });
          await _firestore.collection('jobSeekers').doc(seekerId).update({
            'appliedJobRequests': FieldValue.arrayUnion([appRef.id])
          });
          await _firestore.collection('companies').doc(compId).update({
            'receivedApplications': FieldValue.arrayUnion([appRef.id])
          });
        }
      }
    }

    // 6. Community Posts & Comments
    List<String> postIds = [];
    for (int i = 0; i < 5; i++) {
      String authorId = i % 2 == 0 ? companyIds[0] : jobSeekerIds[0];
      String authorType = i % 2 == 0 ? "Company" : "JobSeeker";
      String authorName = i % 2 == 0 ? "TechCorp Innovations" : "Alice Developer";
      
      final postRef = _firestore.collection('posts').doc();
      postIds.add(postRef.id);
      
      final post = PostModel(
        postID: postRef.id,
        authorID: authorId,
        authorName: authorName,
        authorProfilePic: "https://ui-avatars.com/api/?name=A",
        authorType: authorType,
        title: "Community Discussion $i",
        content: "What are the best practices for Flutter development in 2026? Let's discuss!",
        likedByUserIDs: [],
        totalCommentCount: 2,
        mediaFiles: [],
        createdAt: DateTime.now(),
      );
      await postRef.set(post.toMap());

      // Add 2 Comments
      for (int c = 0; c < 2; c++) {
        String commenterId = jobSeekerIds[c+1];
        final commentRef = _firestore.collection('comments').doc();
        final comment = CommentModel(
          commentID: commentRef.id,
          postID: postRef.id,
          authorID: commenterId,
          authorName: "Seeker ${c+1}",
          commentText: "I totally agree! Great point.",
          createdAt: DateTime.now(),
        );
        await commentRef.set(comment.toMap());
      }
    }

    // 7. Tests, Questions, Results
    final testRef = _firestore.collection('tests').doc();
    final test = TestModel(
      testID: testRef.id,
      testName: "Flutter Proficiency",
      skillID: "flutter_skill_1",
      testType: "Pure",
      totalQuestions: 2,
      durationMinutes: 10,
      passingScore: 50.0,
      questions: [
        QuestionModel(
          questionID: "q1",
          questionText: "What is a StatefulWidget?",
          options: ["A widget that has mutable state", "A stateless widget", "A function", "None of the above"],
          correctAnswer: "A widget that has mutable state",
          marks: 50,
        ),
        QuestionModel(
          questionID: "q2",
          questionText: "What does crossAxisAlignment do in a Row?",
          options: ["Aligns vertically", "Aligns horizontally", "Changes color", "Sets width"],
          correctAnswer: "Aligns vertically",
          marks: 50,
        ),
      ]
    );
    await testRef.set(test.toMap());

    for (int i = 0; i < 3; i++) {
      String seekerId = jobSeekerIds[i];
      final resRef = _firestore.collection('results').doc();
      final result = ResultModel(
        resultID: resRef.id,
        jobSeekerID: seekerId,
        testID: testRef.id,
        score: i == 0 ? 100.0 : 40.0,
        isPassed: i == 0,
        startedAt: DateTime.now().subtract(Duration(minutes: 15)),
        completedAt: DateTime.now(),
        timeTakenSeconds: 600,
        attemptNumber: 1,
        lastAttemptAt: DateTime.now(),
        experienceLevel: "Mid",
        cooldownUntil: i == 0 ? null : DateTime.now().add(Duration(days: 1)),
        badgeEarned: null,
      );
      await resRef.set(result.toMap());
      
      await _firestore.collection('jobSeekers').doc(seekerId).update({
        'totalTestsTaken': FieldValue.increment(1)
      });
    }

    // Sign out so user can log in with newly created accounts
    await _auth.signOut();
    debugPrint("Data Seeding Completed!");
  }

  Future<void> clearDemoData() async {
    final emails = [
      "admin@test.com",
      "company1@test.com",
      "company2@test.com",
      "company3@test.com",
      "seeker1@test.com",
      "seeker2@test.com",
      "seeker3@test.com",
      "seeker4@test.com",
      "seeker5@test.com",
      "seeker6@test.com",
    ];

    for (var email in emails) {
      try {
        UserCredential uc = await _auth.signInWithEmailAndPassword(
            email: email, password: "Test@123");
        String uid = uc.user!.uid;
        
        // Try deleting their documents in case they exist
        await _firestore.collection('admins').doc(uid).delete();
        await _firestore.collection('companies').doc(uid).delete();
        await _firestore.collection('jobSeekers').doc(uid).delete();
        
        await uc.user!.delete();
        debugPrint("Deleted user $email");
      } catch (e) {
        debugPrint("Could not delete $email (may not exist)");
      }
    }
  }

  Future<String> _createUser(String email, String password) async {
    try {
      // Check if user exists (to avoid duplicate emails failing hard)
      // Since we don't have listUsers, we just try to create.
      UserCredential uc = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return uc.user!.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        debugPrint("User $email already exists, trying to sign in instead...");
        try {
           UserCredential uc = await _auth.signInWithEmailAndPassword(email: email, password: password);
           return uc.user!.uid;
        } catch (signInErr) {
           debugPrint("Failed to sign in existing user $email: $signInErr");
           return '';
        }
      }
      debugPrint("Error creating user $email: $e");
      return '';
    } catch (e) {
      debugPrint("General Error creating user $email: $e");
      return '';
    }
  }
}
