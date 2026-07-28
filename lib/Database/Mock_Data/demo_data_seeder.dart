import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/admin_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_seeker_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_post_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/test_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/question_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/result_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/skill_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/education_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_experience_model.dart';

class DemoDataSeeder {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> seedAllData() async {
    debugPrint("Clearing old demo data first...");
    await clearDemoData();

    debugPrint("Starting enhanced demo data seeding...");

    // ── Ensure user is authenticated for request.auth != null Firestore Rules ──
    String adminId = await _createUser("admin@test.com", "Test@123");
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
      try {
        await _firestore.collection('admins').doc(adminId).set(admin.toMap());
      } catch (e) {
        debugPrint("Admin doc write: $e");
      }
    }

    // ── 1. Seed Skills ────────────────────────────────────────────────────────
    final skillsData = [
      SkillModel(
        skillID: 'skill_flutter',
        skillName: 'Flutter Development',
        skillDescription: 'Cross-platform mobile & web development with Dart & Flutter.',
        skillImage: 'https://ui-avatars.com/api/?name=Flutter',
        category: 'Mobile Development',
      ),
      SkillModel(
        skillID: 'skill_python',
        skillName: 'Python Backend',
        skillDescription: 'Backend APIs, FastAPI, Django, & scalable systems.',
        skillImage: 'https://ui-avatars.com/api/?name=Python',
        category: 'Backend Development',
      ),
      SkillModel(
        skillID: 'skill_uiux',
        skillName: 'UI/UX Design',
        skillDescription: 'User research, wireframing, Figma prototyping, and design systems.',
        skillImage: 'https://ui-avatars.com/api/?name=UIUX',
        category: 'Design',
      ),
      SkillModel(
        skillID: 'skill_data',
        skillName: 'Data Science',
        skillDescription: 'Data engineering, Machine Learning, Pandas, and Analytics.',
        skillImage: 'https://ui-avatars.com/api/?name=Data',
        category: 'Data Science',
      ),
    ];

    for (var s in skillsData) {
      try {
        await _firestore.collection('skills').doc(s.skillID).set(s.toMap());
      } catch (e) {
        debugPrint("Skill write error (${s.skillID}): $e");
      }
    }

    // ── 2. Seed Tests for Skills ─────────────────────────────────────────────
    final testsData = [
      TestModel(
        testID: 'test_flutter_01',
        skillID: 'skill_flutter',
        testName: 'Flutter & Dart Mastery Test',
        testType: 'Pure',
        totalQuestions: 2,
        durationMinutes: 15,
        passingScore: 50.0,
        questions: [
          QuestionModel(
            questionID: 'q_f1',
            questionText: 'What is a StatefulWidget in Flutter?',
            options: ['Widget with mutable state', 'Stateless widget', 'Function', 'Constant'],
            correctAnswer: 'Widget with mutable state',
            marks: 50,
          ),
          QuestionModel(
            questionID: 'q_f2',
            questionText: 'Which keyword handles asynchronous operations in Dart?',
            options: ['async / await', 'thread', 'promise', 'sync'],
            correctAnswer: 'async / await',
            marks: 50,
          ),
        ],
      ),
      TestModel(
        testID: 'test_python_01',
        skillID: 'skill_python',
        testName: 'Python Backend Engineering Test',
        testType: 'Pure',
        totalQuestions: 2,
        durationMinutes: 15,
        passingScore: 50.0,
        questions: [
          QuestionModel(
            questionID: 'q_p1',
            questionText: 'What decorator is used for GET endpoints in FastAPI?',
            options: ['@app.get()', '@get()', '@route()', '@api()'],
            correctAnswer: '@app.get()',
            marks: 50,
          ),
          QuestionModel(
            questionID: 'q_p2',
            questionText: 'Which library is standard for async IO in Python?',
            options: ['asyncio', 'multiprocessing', 'threads', 'requests'],
            correctAnswer: 'asyncio',
            marks: 50,
          ),
        ],
      ),
      TestModel(
        testID: 'test_uiux_01',
        skillID: 'skill_uiux',
        testName: 'UI/UX Design Principles Test',
        testType: 'Pure',
        totalQuestions: 2,
        durationMinutes: 15,
        passingScore: 50.0,
        questions: [
          QuestionModel(
            questionID: 'q_u1',
            questionText: 'What does UX stand for?',
            options: ['User Experience', 'User Extension', 'Universal Execution', 'Unit eXperience'],
            correctAnswer: 'User Experience',
            marks: 50,
          ),
          QuestionModel(
            questionID: 'q_u2',
            questionText: 'What is wireframing used for?',
            options: ['Structural visual blueprint', 'Color palette picker', 'Database modeling', 'Code syntax'],
            correctAnswer: 'Structural visual blueprint',
            marks: 50,
          ),
        ],
      ),
      TestModel(
        testID: 'test_data_01',
        skillID: 'skill_data',
        testName: 'Data Science & Analysis Test',
        testType: 'Pure',
        totalQuestions: 2,
        durationMinutes: 15,
        passingScore: 50.0,
        questions: [
          QuestionModel(
            questionID: 'q_d1',
            questionText: 'Which Python library is primary for dataframes?',
            options: ['pandas', 'requests', 'flask', 'sys'],
            correctAnswer: 'pandas',
            marks: 50,
          ),
          QuestionModel(
            questionID: 'q_d2',
            questionText: 'What is supervised learning?',
            options: ['Training with labeled data', 'Unlabeled data clustering', 'Manual coding', 'Rule engine'],
            correctAnswer: 'Training with labeled data',
            marks: 50,
          ),
        ],
      ),
    ];

    for (var t in testsData) {
      try {
        await _firestore.collection('tests').doc(t.testID).set(t.toMap());
      } catch (e) {
        debugPrint("Test write error (${t.testID}): $e");
      }
    }

    // ── 4. Seed Companies ─────────────────────────────────────────────────────
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
        "name": "DataGen Analytics",
        "industry": "Data & AI",
        "logo": "https://ui-avatars.com/api/?name=DA"
      },
    ];

    List<String> companyIds = [];
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
          location: "San Francisco, USA",
          companySize: 100,
          activeJobs: 0,
          followersCount: 0,
          followers: [],
          followRequests: [],
          employeeList: [],
          companyWeaknessList: [],
          companyStrengthList: [],
          achievementList: ["Top Employer 2025", "Innovation Award"],
          receivedApplications: [],
          postedJobs: [],
        );
        await _firestore.collection('companies').doc(uid).set(company.toMap());
      }
    }

    // ── 5. Seed Job Seekers ───────────────────────────────────────────────────
    final List<Map<String, dynamic>> seekerData = [
      {
        "email": "seeker1@test.com",
        "name": "Alice Developer",
        "level": "Mid",
        "desc": "Flutter & UI/UX Specialist",
      },
      {
        "email": "seeker2@test.com",
        "name": "Bob Backend",
        "level": "Senior",
        "desc": "Python Backend Engineer",
      },
      {
        "email": "seeker3@test.com",
        "name": "Charlie Data",
        "level": "Junior",
        "desc": "Junior Data Analyst",
      },
      {
        "email": "seeker4@test.com",
        "name": "Diana Fresh",
        "level": "Junior",
        "desc": "Fresh Graduate (No Passed Skills Yet)",
      },
      {
        "email": "seeker5@test.com",
        "name": "Evan Junior",
        "level": "Junior",
        "desc": "Junior Flutter Developer",
      },
    ];

    List<String> jobSeekerIds = [];
    for (var sData in seekerData) {
      String uid = await _createUser(sData["email"] as String, "Test@123");
      if (uid.isNotEmpty) {
        jobSeekerIds.add(uid);
        final seeker = JobSeekerModel(
          jobSeekerID: uid,
          name: sData["name"] as String,
          email: sData["email"] as String,
          password: "Test@123",
          userType: "JobSeeker",
          profilePic: "https://ui-avatars.com/api/?name=${(sData["name"] as String)[0]}",
          location: "New York, USA",
          about: "Passionate developer looking for new opportunities.",
          shortDescription: sData["desc"] as String,
          experienceLevel: sData["level"] as String,
          skillCount: 2,
          following: [],
          followers: [],
          followRequests: [],
          followedCompanies: companyIds.isNotEmpty ? [companyIds[0]] : [],
          postList: [],
          portfolio: [],
          totalTestsTaken: 0,
          appliedJobRequests: [],
          becomeEmployee: [],
          careerGuidanceTasks: [],
          earnedBadges: [],
          totalBadgesEarned: 0,
          education: [
            EducationModel(year: "2023", title: "BSc Computer Science", school: "Tech University")
          ],
          jobExperience: [
            JobExperienceModel(jobTitle: "Developer", company: "Tech Startup", from: "2023", to: "2025")
          ],
        );
        await _firestore.collection('jobSeekers').doc(uid).set(seeker.toMap());
      }
    }

    // ── 6. Seed Test Results (Passed & Failed Skills) ────────────────────────
    // Alice (seeker1): Passed Flutter (95 - Gold) & Passed UI/UX (80 - Silver)
    if (jobSeekerIds.isNotEmpty) {
      await _addResult(
        jobSeekerID: jobSeekerIds[0],
        testID: 'test_flutter_01',
        score: 95.0,
        isPassed: true,
        level: 'Senior',
      );
      await _addResult(
        jobSeekerID: jobSeekerIds[0],
        testID: 'test_uiux_01',
        score: 80.0,
        isPassed: true,
        level: 'Mid',
      );
    }

    // Bob (seeker2): Passed Python (92 - Gold) & Failed Flutter (40)
    if (jobSeekerIds.length > 1) {
      await _addResult(
        jobSeekerID: jobSeekerIds[1],
        testID: 'test_python_01',
        score: 92.0,
        isPassed: true,
        level: 'Senior',
      );
      await _addResult(
        jobSeekerID: jobSeekerIds[1],
        testID: 'test_flutter_01',
        score: 40.0,
        isPassed: false,
        level: 'Intern',
      );
    }

    // Charlie (seeker3): Passed Data Science (65 - Bronze)
    if (jobSeekerIds.length > 2) {
      await _addResult(
        jobSeekerID: jobSeekerIds[2],
        testID: 'test_data_01',
        score: 65.0,
        isPassed: true,
        level: 'Intern',
      );
    }

    // Diana (seeker4): NO passed skills (Tests taken = 0 or failed)
    // Perfect for testing 10+10+10 random sampling logic!

    // Evan (seeker5): Passed Flutter (55 - Bronze)
    if (jobSeekerIds.length > 4) {
      await _addResult(
        jobSeekerID: jobSeekerIds[4],
        testID: 'test_flutter_01',
        score: 55.0,
        isPassed: true,
        level: 'Intern',
      );
    }

    // ── 7. Seed Job Posts in 'jobs' Collection (using real skillIDs & tiers) ──
    if (companyIds.isNotEmpty) {
      final jobsToSeed = [
        // ── Flutter Jobs (skill_flutter) ──
        {
          "title": "Flutter Mobile Intern",
          "skill": "skill_flutter",
          "tier": "Internship", // Bronze
          "salary": "\$20,000 - \$30,000",
          "compId": companyIds[0],
          "type": "Remote",
        },
        {
          "title": "Mid-Level Flutter Developer",
          "skill": "skill_flutter",
          "tier": "1 to 5 years", // Silver
          "salary": "\$70,000 - \$90,000",
          "compId": companyIds[0],
          "type": "Full-time",
        },
        {
          "title": "Senior Flutter Architect",
          "skill": "skill_flutter",
          "tier": "5+ years", // Gold
          "salary": "\$130,000 - \$160,000",
          "compId": companyIds[0],
          "type": "Full-time",
        },

        // ── Python Jobs (skill_python) ──
        {
          "title": "Junior Python Developer",
          "skill": "skill_python",
          "tier": "0 years", // Bronze
          "salary": "\$40,000 - \$55,000",
          "compId": companyIds[0],
          "type": "Full-time",
        },
        {
          "title": "Python API Backend Engineer",
          "skill": "skill_python",
          "tier": "1-5 years", // Silver
          "salary": "\$85,000 - \$110,000",
          "compId": companyIds[1],
          "type": "Full-time",
        },
        {
          "title": "Lead Python Systems Engineer",
          "skill": "skill_python",
          "tier": "5+ years", // Gold
          "salary": "\$140,000 - \$180,000",
          "compId": companyIds[1],
          "type": "Remote",
        },

        // ── UI/UX Jobs (skill_uiux) ──
        {
          "title": "UI/UX Design Apprentice",
          "skill": "skill_uiux",
          "tier": "Internship", // Bronze
          "salary": "\$25,000 - \$35,000",
          "compId": companyIds[1],
          "type": "Part-time",
        },
        {
          "title": "Product Designer (UI/UX)",
          "skill": "skill_uiux",
          "tier": "Intermediate", // Silver
          "salary": "\$75,000 - \$95,000",
          "compId": companyIds[1],
          "type": "Full-time",
        },
        {
          "title": "Senior UX Lead",
          "skill": "skill_uiux",
          "tier": "Senior", // Gold
          "salary": "\$125,000 - \$150,000",
          "compId": companyIds[1],
          "type": "Full-time",
        },

        // ── Data Science Jobs (skill_data) ──
        {
          "title": "Junior Data Analyst",
          "skill": "skill_data",
          "tier": "Entry Level", // Bronze
          "salary": "\$45,000 - \$60,000",
          "compId": companyIds.length > 2 ? companyIds[2] : companyIds[0],
          "type": "Full-time",
        },
        {
          "title": "Data Engineer (Python & SQL)",
          "skill": "skill_data",
          "tier": "1-5 years", // Silver
          "salary": "\$90,000 - \$115,000",
          "compId": companyIds.length > 2 ? companyIds[2] : companyIds[0],
          "type": "Full-time",
        },
        {
          "title": "Lead Data Scientist (AI/ML)",
          "skill": "skill_data",
          "tier": "5+ years", // Gold
          "salary": "\$150,000 - \$190,000",
          "compId": companyIds.length > 2 ? companyIds[2] : companyIds[0],
          "type": "Remote",
        },
      ];

      for (var jData in jobsToSeed) {
        final jobRef = _firestore.collection('jobs').doc();
        final jobPost = JobPostModel(
          jobID: jobRef.id,
          companyID: jData["compId"] as String,
          title: jData["title"] as String,
          description: "Join our dynamic team for this exciting position. Require proficiency in ${jData["title"]}.",
          requiredSkills: [jData["skill"] as String],
          requiredBadges: [],
          salary: jData["salary"] as String,
          jobType: jData["type"] as String,
          location: "San Francisco, CA",
          experienceLevel: jData["tier"] as String,
          postedAt: DateTime.now().subtract(const Duration(days: 2)),
          applicants: [],
          isExternal: false,
          sourceUrl: '',
          isClosed: false,
        );
        await jobRef.set(jobPost.toMap());

        // Update company active jobs count & array
        await _firestore.collection('companies').doc(jData["compId"] as String).update({
          'activeJobs': FieldValue.increment(1),
          'postedJobs': FieldValue.arrayUnion([jobRef.id]),
        });
      }
    }

    // Sign out so user can switch/login cleanly
    await _auth.signOut();
    debugPrint("Enhanced Demo Data Seeding Completed Successfully!");
  }

  Future<void> _addResult({
    required String jobSeekerID,
    required String testID,
    required double score,
    required bool isPassed,
    required String level,
  }) async {
    final resRef = _firestore.collection('results').doc();
    final result = ResultModel(
      resultID: resRef.id,
      jobSeekerID: jobSeekerID,
      testID: testID,
      score: score,
      isPassed: isPassed,
      startedAt: DateTime.now().subtract(const Duration(minutes: 20)),
      completedAt: DateTime.now(),
      timeTakenSeconds: 900,
      attemptNumber: 1,
      lastAttemptAt: DateTime.now(),
      experienceLevel: level,
    );
    await resRef.set(result.toMap());

    await _firestore.collection('jobSeekers').doc(jobSeekerID).update({
      'totalTestsTaken': FieldValue.increment(1),
    });
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
    ];

    for (var email in emails) {
      try {
        UserCredential uc = await _auth.signInWithEmailAndPassword(
          email: email,
          password: "Test@123",
        );
        String uid = uc.user!.uid;

        try {
          await _firestore.collection('admins').doc(uid).delete();
        } catch (_) {}
        try {
          await _firestore.collection('companies').doc(uid).delete();
        } catch (_) {}
        try {
          await _firestore.collection('jobSeekers').doc(uid).delete();
        } catch (_) {}

        try {
          await uc.user!.delete();
          debugPrint("Deleted auth user $email");
        } catch (e) {
          debugPrint("Could not delete auth user $email: $e");
        }
      } catch (e) {
        debugPrint("Could not sign in/delete $email (may not exist): $e");
      }
    }
  }

  Future<String> _createUser(String email, String password) async {
    try {
      UserCredential uc = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return uc.user!.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        try {
          UserCredential uc = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          return uc.user!.uid;
        } catch (signInErr) {
          debugPrint("Existing user $email password mismatch, using fixed ID...");
          // Fallback to deterministic UID so doc creation in Firestore succeeds
          return "demo_${email.replaceAll('@', '_').replaceAll('.', '_')}";
        }
      }
      return "demo_${email.replaceAll('@', '_').replaceAll('.', '_')}";
    } catch (e) {
      return "demo_${email.replaceAll('@', '_').replaceAll('.', '_')}";
    }
  }
}

