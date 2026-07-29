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
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/project_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/post_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/application_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_employee_model.dart';

class DemoDataSeeder {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _demoFileDownloadUrl =
      'https://firebasestorage.googleapis.com/v0/b/elevate-988ab.firebasestorage.app/o/demo_files%2Fsample_test_file.txt?alt=media&token=8d505597-cdc0-4153-9320-a4eb5c0129b2';

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
        "email": "company99@test.com",
        "name": "TechCorp Innovations",
        "industry": "Software Development",
        "logo": "https://ui-avatars.com/api/?name=TC"
      },
      {
        "email": "company98@test.com",
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
      // ── Review-test company (fresh, never reviewed) ──────────────
      {
        "email": "reviewco@test.com",
        "name": "ReviewTest Co",
        "industry": "Technology",
        "logo": "https://ui-avatars.com/api/?name=RT"
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
        "email": "seeker99@test.com",
        "name": "Ahmad Raza",
        "level": "Mid",
        "desc": "Flutter & UI/UX Specialist",
      },
      {
        "email": "seeker2@test.com",
        "name": "Usman Tariq",
        "level": "Senior",
        "desc": "Python Backend Engineer",
      },
      {
        "email": "seeker3@test.com",
        "name": "Yusuf Malik",
        "level": "Junior",
        "desc": "Junior Data Analyst",
      },
      {
        "email": "seeker4@test.com",
        "name": "Fatima Noor",
        "level": "Junior",
        "desc": "Fresh Graduate (No Passed Skills Yet)",
      },
      {
        "email": "seeker5@test.com",
        "name": "Hassan Ali",
        "level": "Junior",
        "desc": "Junior Flutter Developer",
      },
      // ── Review-test seeker (fresh, never reviewed anything) ──────────
      {
        "email": "reviewer@test.com",
        "name": "Review Tester",
        "level": "Mid",
        "desc": "Dedicated review test account",
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
    // Ahmad Raza (seeker1): Passed Flutter (95 - Gold) & Passed UI/UX (80 - Silver)
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

    // Usman Tariq (seeker2): Passed Python (92 - Gold) & Failed Flutter (40)
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

    // Yusuf Malik (seeker3): Passed Data Science (65 - Bronze)
    if (jobSeekerIds.length > 2) {
      await _addResult(
        jobSeekerID: jobSeekerIds[2],
        testID: 'test_data_01',
        score: 65.0,
        isPassed: true,
        level: 'Intern',
      );
    }

    // Fatima Noor (seeker4): NO passed skills (Tests taken = 0 or failed)
    // Perfect for testing 10+10+10 random sampling logic!

    // Hassan Ali (seeker5): Passed Flutter (55 - Bronze)
    if (jobSeekerIds.length > 4) {
      await _addResult(
        jobSeekerID: jobSeekerIds[4],
        testID: 'test_flutter_01',
        score: 55.0,
        isPassed: true,
        level: 'Intern',
      );
    }
    if (jobSeekerIds.isNotEmpty) {
      final sampleProjects = [
        {
          "seekerId": jobSeekerIds[0],
          "title": "Elevate E-Learning Mobile App",
          "desc": "A full-featured mobile app built with Flutter and Firebase featuring AI skill assessments.",
          "url": "https://github.com/example/elevate_app",
          "techStack": ["sample_test_file.txt"],
          "techFileUrls": [_demoFileDownloadUrl],
        },
        {
          "seekerId": jobSeekerIds[0],
          "title": "Crypto Wallet UI Kit",
          "desc": "Modern clean crypto wallet design system with dynamic dark mode and custom interactive charts.",
          "url": "https://github.com/example/crypto_ui",
          "techStack": ["sample_test_file.txt"],
          "techFileUrls": [_demoFileDownloadUrl],
        },
        {
          "seekerId": jobSeekerIds.length > 1 ? jobSeekerIds[1] : jobSeekerIds[0],
          "title": "FastAPI Microservices Infrastructure",
          "desc": "Scalable RESTful API gateway integrated with Redis caching and Dockerized deployments.",
          "url": "https://github.com/example/fastapi_gateway",
          "techStack": ["sample_test_file.txt"],
          "techFileUrls": [_demoFileDownloadUrl],
        },
        {
          "seekerId": jobSeekerIds.length > 2 ? jobSeekerIds[2] : jobSeekerIds[0],
          "title": "Automated Stock Sentiment Analysis",
          "desc": "Python ML pipeline fetching financial news and rendering real-time sentiment metrics.",
          "url": "https://github.com/example/stock_sentiment",
          "techStack": ["sample_test_file.txt"],
          "techFileUrls": [_demoFileDownloadUrl],
        },
        if (jobSeekerIds.length > 3)
          {
            "seekerId": jobSeekerIds[3],
            "title": "UI/UX Design Systems & Kit",
            "desc": "Figma design prototypes, wireframes, and design spec documentation for mobile & web apps.",
            "url": "https://github.com/example/uiux_portfolio",
            "techStack": ["sample_test_file.txt"],
            "techFileUrls": [_demoFileDownloadUrl],
          },
        if (jobSeekerIds.length > 4)
          {
            "seekerId": jobSeekerIds[4],
            "title": "Flutter Cross-Platform Architecture",
            "desc": "Clean architecture template with state management and comprehensive test suite.",
            "url": "https://github.com/example/flutter_architecture",
            "techStack": ["sample_test_file.txt"],
            "techFileUrls": [_demoFileDownloadUrl],
          },
      ];

      for (var p in sampleProjects) {
        final projRef = _firestore.collection('projects').doc();
        final project = ProjectModel(
          projectID: projRef.id,
          jobSeekerID: p["seekerId"] as String,
          projectTitle: p["title"] as String,
          projectDescription: p["desc"] as String,
          projectURL: p["url"] as String,
          techStack: List<String>.from(p["techStack"] as List),
          techFileUrls: List<String>.from(p["techFileUrls"] as List),
        );
        await projRef.set(project.toMap());

        // Update seeker portfolio array
        await _firestore.collection('jobSeekers').doc(p["seekerId"] as String).update({
          'portfolio': FieldValue.arrayUnion([projRef.id]),
        });
      }
    }

    // ── 8. Seed Posts for Job Seekers & Companies ──────────────────────────
    if (jobSeekerIds.isNotEmpty) {
      final samplePosts = [
        {
          "authorId": jobSeekerIds[0],
          "name": "Ahmad Raza",
          "pic": "https://ui-avatars.com/api/?name=Ahmad+Raza",
          "type": "JobSeeker",
          "title": "Excited to share my latest Flutter project!",
          "content": "Just published a complete open-source design kit for Flutter apps. Check out my portfolio!",
        },
        {
          "authorId": jobSeekerIds.length > 1 ? jobSeekerIds[1] : jobSeekerIds[0],
          "name": "Usman Tariq",
          "pic": "https://ui-avatars.com/api/?name=Usman+Tariq",
          "type": "JobSeeker",
          "title": "Python 3.12 Performance Tweaks",
          "content": "Here are 5 tips to speed up your FastAPI async endpoints by 40% using connection pooling.",
        },
      ];

      if (companyIds.isNotEmpty) {
        samplePosts.add({
          "authorId": companyIds[0],
          "name": "TechCorp Innovations",
          "pic": "https://ui-avatars.com/api/?name=TC",
          "type": "Company",
          "title": "We are Hiring Mobile & Backend Engineers!",
          "content": "TechCorp is expanding rapidly! Check our active job listings and apply directly on Elevate.",
        });
      }

      for (var post in samplePosts) {
        final postRef = _firestore.collection('posts').doc();
        final postModel = PostModel(
          postID: postRef.id,
          authorID: post["authorId"] as String,
          authorName: post["name"] as String,
          authorProfilePic: post["pic"] as String,
          authorType: post["type"] as String,
          title: post["title"] as String,
          content: post["content"] as String,
          likes: 5,
        );
        await postRef.set(postModel.toMap());

        if (post["type"] == "JobSeeker") {
          await _firestore.collection('jobSeekers').doc(post["authorId"] as String).update({
            'postList': FieldValue.arrayUnion([postRef.id]),
          });
        }
      }
    }

    // ── 9. Seed Job Posts & Applicants ──────────────────────────────────────
    if (companyIds.isNotEmpty) {
      final jobsToSeed = [
        // ── Flutter Jobs (skill_flutter) ──
        {
          "title": "Flutter Mobile Intern",
          "skill": "skill_flutter",
          "tier": "Internship",
          "salary": "\$20,000 - \$30,000",
          "compId": companyIds[0],
          "type": "Remote",
          "applicants": jobSeekerIds.take(3).toList(),
        },
        {
          "title": "Mid-Level Flutter Developer",
          "skill": "skill_flutter",
          "tier": "1 to 5 years",
          "salary": "\$70,000 - \$90,000",
          "compId": companyIds[0],
          "type": "Full-time",
          "applicants": jobSeekerIds.take(2).toList(),
        },
        {
          "title": "Senior Flutter Architect",
          "skill": "skill_flutter",
          "tier": "5+ years",
          "salary": "\$130,000 - \$160,000",
          "compId": companyIds[0],
          "type": "Full-time",
          "applicants": jobSeekerIds.isNotEmpty ? [jobSeekerIds[0]] : [],
        },

        // ── Python Jobs (skill_python) ──
        {
          "title": "Junior Python Developer",
          "skill": "skill_python",
          "tier": "0 years",
          "salary": "\$40,000 - \$55,000",
          "compId": companyIds[0],
          "type": "Full-time",
          "applicants": jobSeekerIds.length > 1 ? [jobSeekerIds[1]] : [],
        },
        {
          "title": "Python API Backend Engineer",
          "skill": "skill_python",
          "tier": "1-5 years",
          "salary": "\$85,000 - \$110,000",
          "compId": companyIds[1],
          "type": "Full-time",
          "applicants": jobSeekerIds.length > 2 ? [jobSeekerIds[1], jobSeekerIds[2]] : [],
        },

        // ── UI/UX Jobs (skill_uiux) ──
        {
          "title": "Product Designer (UI/UX)",
          "skill": "skill_uiux",
          "tier": "Intermediate",
          "salary": "\$75,000 - \$95,000",
          "compId": companyIds[1],
          "type": "Full-time",
          "applicants": jobSeekerIds.isNotEmpty ? [jobSeekerIds[0]] : [],
        },

        // ── Data Science Jobs (skill_data) ──
        {
          "title": "Junior Data Analyst",
          "skill": "skill_data",
          "tier": "Entry Level",
          "salary": "\$45,000 - \$60,000",
          "compId": companyIds.length > 2 ? companyIds[2] : companyIds[0],
          "type": "Full-time",
          "applicants": jobSeekerIds.length > 2 ? [jobSeekerIds[2]] : [],
        },
      ];

      for (var jData in jobsToSeed) {
        final jobRef = _firestore.collection('jobs').doc();
        final List<String> applicants = List<String>.from(jData["applicants"] as List);

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
          applicants: applicants,
          isExternal: false,
          sourceUrl: '',
          isClosed: false,
        );
        await jobRef.set(jobPost.toMap());

        // Create matching ApplicationModel entries & update seekers
        for (String seekerId in applicants) {
          final appRef = _firestore.collection('applications').doc();
          final appModel = ApplicationModel(
            applicationID: appRef.id,
            jobID: jobRef.id,
            jobSeekerID: seekerId,
            companyID: jData["compId"] as String,
            status: "Pending",
            coldEmail: "Hello, I am very interested in the ${jData["title"]} role and believe my skills align well with your team.",
            resumeUrl: _demoFileDownloadUrl,
          );
          await appRef.set(appModel.toMap());

          await _firestore.collection('jobSeekers').doc(seekerId).update({
            'appliedJobRequests': FieldValue.arrayUnion([appRef.id]),
          });
        }

        // Update company active jobs count & array & receivedApplications
        await _firestore.collection('companies').doc(jData["compId"] as String).update({
          'activeJobs': FieldValue.increment(1),
          'postedJobs': FieldValue.arrayUnion([jobRef.id]),
        });
      }
    }

    // ── 10. Seed Employee Requests for Companies ───────────────────────────
    if (companyIds.isNotEmpty && jobSeekerIds.length >= 4) {
      final empRequests = [
        {
          "companyId": companyIds[0],
          "seekerId": jobSeekerIds[0],
          "position": "Flutter Mobile Developer",
          "status": "Pending",
        },
        {
          "companyId": companyIds[0],
          "seekerId": jobSeekerIds[1],
          "position": "Backend Developer",
          "status": "Active", // Active for testing dashboard home screen
        },
        {
          "companyId": companyIds[0],
          "seekerId": jobSeekerIds[2],
          "position": "Data Analyst",
          "status": "Pending",
        },
        {
          "companyId": companyIds[0],
          "seekerId": jobSeekerIds[3],
          "position": "Junior Developer",
          "status": "Active",
        },
        {
          "companyId": companyIds[0],
          "seekerId": jobSeekerIds[4],
          "position": "Junior Flutter Developer",
          "status": "Pending",
        },
        // ── Review-test: reviewer@test.com is Active at reviewco@test.com ──
        if (companyIds.length > 3 && jobSeekerIds.length > 5)
          {
            "companyId": companyIds[3], // reviewco@test.com
            "seekerId": jobSeekerIds[5], // reviewer@test.com
            "position": "Senior Engineer",
            "status": "Active",
          },
        // --- Added pending requests for companyIds[1] (Creative Studio) ---
        {
          "companyId": companyIds[1],
          "seekerId": jobSeekerIds[2],
          "position": "UI/UX Designer",
          "status": "Pending",
        },
        {
          "companyId": companyIds[1],
          "seekerId": jobSeekerIds[3],
          "position": "Senior Graphic Designer",
          "status": "Pending",
        },
        {
          "companyId": companyIds[1],
          "seekerId": jobSeekerIds[4],
          "position": "Art Director",
          "status": "Pending",
        },
      ];

      for (var req in empRequests) {
        final empRef = _firestore.collection('employees').doc();
        final empModel = CompanyEmployeeModel(
          employeeID: empRef.id,
          jobSeekerID: req["seekerId"] as String,
          companyID: req["companyId"] as String,
          position: req["position"] as String,
          employeeStatus: req["status"] as String,
        );
        await empRef.set(empModel.toMap());

        if (req["status"] == "Active") {
          await _firestore.collection('companies').doc(req["companyId"] as String).update({
            'employeeList': FieldValue.arrayUnion([empRef.id]),
          });
          await _firestore.collection('jobSeekers').doc(req["seekerId"] as String).update({
            'becomeEmployee': FieldValue.arrayUnion([empRef.id]),
          });
        }
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
      "company99@test.com",
      "company98@test.com",
      "company3@test.com",
      "seeker99@test.com",
      "seeker2@test.com",
      "seeker3@test.com",
      "seeker4@test.com",
      "seeker5@test.com",
    ];

    for (var email in emails) {
      String? uid;
      try {
        UserCredential uc = await _auth.signInWithEmailAndPassword(
          email: email,
          password: "Test@123",
        );
        uid = uc.user?.uid;
      } catch (_) {}

      uid ??= "demo_${email.replaceAll('@', '_').replaceAll('.', '_')}";

      try {
        await _firestore.collection('admins').doc(uid).delete();
      } catch (_) {}
      try {
        await _firestore.collection('companies').doc(uid).delete();
      } catch (_) {}
      try {
        await _firestore.collection('jobSeekers').doc(uid).delete();
      } catch (_) {}

      // Delete associated user data
      try {
        final projectsSnap = await _firestore.collection('projects').where('jobSeekerID', isEqualTo: uid).get();
        for (var doc in projectsSnap.docs) {
          await doc.reference.delete();
        }
      } catch (_) {}
      try {
        final postsSnap = await _firestore.collection('posts').where('authorID', isEqualTo: uid).get();
        for (var doc in postsSnap.docs) {
          await doc.reference.delete();
        }
      } catch (_) {}
      try {
        final appsSnap1 = await _firestore.collection('applications').where('jobSeekerID', isEqualTo: uid).get();
        for (var doc in appsSnap1.docs) {
          await doc.reference.delete();
        }
        final appsSnap2 = await _firestore.collection('applications').where('companyID', isEqualTo: uid).get();
        for (var doc in appsSnap2.docs) {
          await doc.reference.delete();
        }
      } catch (_) {}
      try {
        final empSnap1 = await _firestore.collection('employees').where('jobSeekerID', isEqualTo: uid).get();
        for (var doc in empSnap1.docs) {
          await doc.reference.delete();
        }
        final empSnap2 = await _firestore.collection('employees').where('companyID', isEqualTo: uid).get();
        for (var doc in empSnap2.docs) {
          await doc.reference.delete();
        }
      } catch (_) {}
      try {
        final resSnap = await _firestore.collection('results').where('jobSeekerID', isEqualTo: uid).get();
        for (var doc in resSnap.docs) {
          await doc.reference.delete();
        }
      } catch (_) {}
      try {
        final jobsSnap = await _firestore.collection('jobs').where('companyID', isEqualTo: uid).get();
        for (var doc in jobsSnap.docs) {
          await doc.reference.delete();
        }
      } catch (_) {}
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

