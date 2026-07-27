import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/skill_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/admin_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/application_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/badge_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/career_guidance_task_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/comment_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_employee_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/follow_request_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_post_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/post_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/project_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/result_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/review_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/test_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_seeker_model.dart';

class FirebaseService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Job Seeker
  Future<void> saveJobSeeker(JobSeekerModel jobSeeker) async {
    await db
        .collection('jobSeekers')
        .doc(jobSeeker.jobSeekerID)
        .set(jobSeeker.toMap());
  }

  Future<JobSeekerModel?> getJobSeeker(String jobSeekerID) async {
    final doc = await db.collection('jobSeekers').doc(jobSeekerID).get();
    if (!doc.exists) return null;
    return JobSeekerModel.fromMap(doc.data()!);
  }

  Future<void> updateJobSeeker(
    String jobSeekerID,
    Map<String, dynamic> newData,
  ) async {
    await db.collection('jobSeekers').doc(jobSeekerID).update(newData);
  }

  Future<void> updateJobSeekerPassword(
    String jobSeekerID,
    String newPassword,
  ) async {
    await FirebaseFirestore.instance
        .collection('jobSeekers')
        .doc(jobSeekerID)
        .update({'password': newPassword});
  }

  Future<void> updateCompanyPassword(
    String companyID,
    String newPassword,
  ) async {
    await FirebaseFirestore.instance
        .collection('companies')
        .doc(companyID)
        .update({'password': newPassword});
  }

  Future<void> updateAdminPassword(String adminID, String newPassword) async {
    await FirebaseFirestore.instance.collection('admins').doc(adminID).update({
      'password': newPassword,
    });
  }

  Future<void> deleteJobSeeker(String jobSeekerID) async {
    await db.collection('jobSeekers').doc(jobSeekerID).delete();
  }

  Future<List<JobSeekerModel>> listAllJobSeekers() async {
    final snap = await db.collection('jobSeekers').get();
    return snap.docs.map((d) => JobSeekerModel.fromMap(d.data())).toList();
  }

  Future<JobSeekerModel?> searchJobSeeker(String jobSeekerID) =>
      getJobSeeker(jobSeekerID);

  Future<List<JobSeekerModel>> searchJobSeekersByName(String nameQuery) async {
    final snap = await db
        .collection('jobSeekers')
        .where('name', isGreaterThanOrEqualTo: nameQuery)
        .where('name', isLessThanOrEqualTo: '$nameQuery\uf8ff')
        .get();
    return snap.docs.map((d) => JobSeekerModel.fromMap(d.data())).toList();
  }

  // Follow / Social
  // followUser — add a targetCollection param so a seeker can follow a company too
  Future<void> followUser(
    String fromID,
    String toID, {
    String toCollection = 'jobSeekers',
  }) async {
    final requestID = db.collection('followRequests').doc().id;
    final request = FollowRequestModel(
      requestID: requestID,
      fromID: fromID,
      toID: toID,
    );

    final batch = db.batch();
    batch.set(db.collection('followRequests').doc(requestID), request.toMap());
    batch.update(db.collection(toCollection).doc(toID), {
      'followRequests': FieldValue.arrayUnion([requestID]),
    });
    await batch.commit();
  }

  // Undo an already-accepted follow relationship. (Previously lived in
  // firebase_service_community_extensions.dart — merged in here.)
  Future<void> unfollowUser(
    String fromID,
    String toID, {
    String toCollection = 'jobSeekers',
  }) async {
    final batch = db.batch();
    batch.update(db.collection('jobSeekers').doc(fromID), {
      'following': FieldValue.arrayRemove([toID]),
      if (toCollection == 'companies')
        'followedCompanies': FieldValue.arrayRemove([toID]),
    });
    batch.update(db.collection(toCollection).doc(toID), {
      'followers': FieldValue.arrayRemove([fromID]),
    });
    await batch.commit();
  }

  Future<bool> acceptFollowRequestForJobSeeker(
    String requestID, {
    String toCollection = 'jobSeekers',
  }) async {
    final req = await getFollowRequest(requestID);
    if (req == null) return false;

    final batch = db.batch();
    batch.update(db.collection('followRequests').doc(requestID), {
      'status': 'Accepted',
    });
    batch.update(db.collection(toCollection).doc(req.toID), {
      'followers': FieldValue.arrayUnion([req.fromID]),
      'followRequests': FieldValue.arrayRemove([requestID]),
    });
    batch.update(db.collection('jobSeekers').doc(req.fromID), {
      'following': FieldValue.arrayUnion([req.toID]),
      if (toCollection == 'companies')
        'followedCompanies': FieldValue.arrayUnion([req.toID]),
    });
    await batch.commit();
    return true;
  }

  // Returns 'Following' if fromID already follows toID, 'Pending' if a
  // follow request is awaiting acceptance, otherwise 'None'. Used by the
  // profile screen to decide whether to show Follow / Requested / Unfollow.
  Future<String> getFollowStatus(String fromID, String toID) async {
    final me = await getJobSeeker(fromID);
    if (me != null && me.following.contains(toID)) return 'Following';

    final snap = await db
        .collection('followRequests')
        .where('fromID', isEqualTo: fromID)
        .where('toID', isEqualTo: toID)
        .where('status', isEqualTo: 'Pending')
        .limit(1)
        .get();
    if (snap.docs.isNotEmpty) return 'Pending';

    return 'None';
  }

  Future<bool> rejectFollowRequestForJobSeeker(
    String requestID, {
    String toCollection = 'jobSeekers',
  }) async {
    final req = await getFollowRequest(requestID);
    if (req == null) return false;

    final batch = db.batch();
    batch.update(db.collection('followRequests').doc(requestID), {
      'status': 'Rejected',
    });
    batch.update(db.collection(toCollection).doc(req.toID), {
      'followRequests': FieldValue.arrayRemove([requestID]),
    });
    await batch.commit();
    return true;
  }

  // Portfolio Project
  Future<void> createPortfolioProject(ProjectModel project) async {
    await db.collection('projects').doc(project.projectID).set(project.toMap());
    await db.collection('jobSeekers').doc(project.jobSeekerID).update({
      'portfolio': FieldValue.arrayUnion([project.projectID]),
    });
  }

  Future<void> editPortfolioProject(
    String projectID,
    Map<String, dynamic> newData,
  ) async {
    await db.collection('projects').doc(projectID).update(newData);
  }

  Future<void> deletePortfolioProject(
    String projectID,
    String jobSeekerID,
  ) async {
    await db.collection('projects').doc(projectID).delete();
    await db.collection('jobSeekers').doc(jobSeekerID).update({
      'portfolio': FieldValue.arrayRemove([projectID]),
    });
  }

  Future<List<ProjectModel>> getPortfolio(String jobSeekerID) async {
    final snap = await db
        .collection('projects')
        .where('jobSeekerID', isEqualTo: jobSeekerID)
        .get();
    return snap.docs.map((d) => ProjectModel.fromMap(d.data())).toList();
  }

  Future<List<ProjectModel>> searchPortfolioByTitle(
    String jobSeekerID,
    String title,
  ) async {
    final all = await getPortfolio(jobSeekerID);
    return all
        .where(
          (p) => p.projectTitle.toLowerCase().contains(title.toLowerCase()),
        )
        .toList();
  }

  // applyAsEmployee — change employeeStatus
  Future<void> applyAsEmployee(
    String jobSeekerID,
    String companyID,
    String position,
  ) async {
    final employeeID = db.collection('employees').doc().id;
    final employee = CompanyEmployeeModel(
      employeeID: employeeID,
      jobSeekerID: jobSeekerID,
      companyID: companyID,
      position: position,
      employeeStatus: 'Pending', // was 'Active'
    );

    final batch = db.batch();
    batch.set(db.collection('employees').doc(employeeID), employee.toMap());
    batch.update(db.collection('jobSeekers').doc(jobSeekerID), {
      'becomeEmployee': FieldValue.arrayUnion([employeeID]),
    });
    batch.update(db.collection('companies').doc(companyID), {
      'employeeList': FieldValue.arrayUnion([employeeID]),
    });
    await batch.commit();
  }

  // Company
  Future<void> saveCompany(CompanyModel company) async {
    await db
        .collection('companies')
        .doc(company.companyID)
        .set(company.toMap());
  }

  Future<CompanyModel?> getCompany(String companyID) async {
    final doc = await db.collection('companies').doc(companyID).get();
    if (!doc.exists) return null;
    return CompanyModel.fromMap(doc.data()!);
  }

  Future<void> updateCompany(
    String companyID,
    Map<String, dynamic> newData,
  ) async {
    await db.collection('companies').doc(companyID).update(newData);
  }

  Future<void> deleteCompany(String companyID) async {
    await db.collection('companies').doc(companyID).delete();
  }

  Future<List<CompanyModel>> listAllCompanies() async {
    final snap = await db.collection('companies').get();
    return snap.docs.map((d) => CompanyModel.fromMap(d.data())).toList();
  }

  Future<CompanyModel?> searchCompany(String companyID) =>
      getCompany(companyID);

  Future<List<CompanyModel>> searchCompaniesByName(String nameQuery) async {
    final snap = await db
        .collection('companies')
        .where('companyName', isGreaterThanOrEqualTo: nameQuery)
        .where('companyName', isLessThanOrEqualTo: '$nameQuery\uf8ff')
        .get();
    return snap.docs.map((d) => CompanyModel.fromMap(d.data())).toList();
  }

  Future<void> acceptEmployeeRequest(String employeeID) async {
    await db.collection('employees').doc(employeeID).update({
      'employeeStatus': 'Active',
    });
  }

  Future<void> rejectEmployeeRequest(
    String employeeID,
    String jobSeekerID,
    String companyID,
  ) async {
    final batch = db.batch();
    batch.delete(db.collection('employees').doc(employeeID));
    batch.update(db.collection('jobSeekers').doc(jobSeekerID), {
      'becomeEmployee': FieldValue.arrayRemove([employeeID]),
    });
    batch.update(db.collection('companies').doc(companyID), {
      'employeeList': FieldValue.arrayRemove([employeeID]),
    });
    await batch.commit();
  }

  Future<ReviewModel> submitEmployeeReview(ReviewModel review) async {
    await saveReview(review);
    // Update company rating
    final companyDoc = await db
        .collection('companies')
        .doc(review.companyID)
        .get();
    if (companyDoc.exists) {
      final reviewsSnap = await db
          .collection('reviews')
          .where('companyID', isEqualTo: review.companyID)
          .get();
      double totalRating = 0;
      for (final doc in reviewsSnap.docs) {
        totalRating += (doc.data()['rating'] as num? ?? 0).toDouble();
      }
      final double avgRating = reviewsSnap.docs.isNotEmpty
          ? totalRating / reviewsSnap.docs.length
          : 0.0;
      await db.collection('companies').doc(review.companyID).update({
        'rating': avgRating,
        'reviewCount': reviewsSnap.docs.length,
      });
    }
    return review;
  }

  // Review
  Future<String> getSentimentSummary(String companyID) async {
    final reviews = await getReviewsByCompany(companyID);
    if (reviews.isEmpty) return 'No reviews yet.';
    final positive = reviews.where((r) => r.sentiment == 'Positive').length;
    final negative = reviews.where((r) => r.sentiment == 'Negative').length;
    final neutral = reviews.length - positive - negative;
    return '$positive positive, $neutral neutral, $negative negative (${reviews.length} total reviews).';
  }

  Future<void> saveReview(ReviewModel review) async {
    await db.collection('reviews').doc(review.reviewID).set(review.toMap());
  }

  Future<List<ReviewModel>> getReviewsByCompany(String companyID) async {
    final snap = await db
        .collection('reviews')
        .where('companyID', isEqualTo: companyID)
        .get();
    return snap.docs.map((d) => ReviewModel.fromMap(d.data())).toList();
  }

  // Admin
  Future<void> saveAdmin(AdminModel admin) async {
    await db.collection('admins').doc(admin.adminID).set(admin.toMap());
  }

  Future<AdminModel?> getAdmin(String adminID) async {
    final doc = await db.collection('admins').doc(adminID).get();
    if (!doc.exists) return null;
    return AdminModel.fromMap(doc.data()!);
  }

  // Company-Employee
  Future<void> saveEmployee(CompanyEmployeeModel employee) async {
    await db
        .collection('employees')
        .doc(employee.employeeID)
        .set(employee.toMap());
  }

  Future<CompanyEmployeeModel?> getEmployee(String employeeID) async {
    final doc = await db.collection('employees').doc(employeeID).get();
    if (!doc.exists) return null;
    return CompanyEmployeeModel.fromMap(doc.data()!);
  }

  Future<List<CompanyEmployeeModel>> getEmployeesByCompany(
    String companyID,
  ) async {
    final snap = await db
        .collection('employees')
        .where('companyID', isEqualTo: companyID)
        .get();
    return snap.docs
        .map((d) => CompanyEmployeeModel.fromMap(d.data()))
        .toList();
  }

  Future<void> updateEmployeePosition(
    String employeeID,
    String newPosition,
  ) async {
    await db.collection('employees').doc(employeeID).update({
      'position': newPosition,
    });
  }

  Future<void> terminateEmployee(String employeeID) async {
    final employee = await getEmployee(employeeID);
    if (employee == null) return;

    final batch = db.batch();
    batch.update(db.collection('employees').doc(employeeID), {
      'employeeStatus': 'Terminated',
      'terminatedAt': DateTime.now().toIso8601String(),
    });
    batch.update(db.collection('jobSeekers').doc(employee.jobSeekerID), {
      'becomeEmployee': FieldValue.arrayRemove([employeeID]),
    });
    batch.update(db.collection('companies').doc(employee.companyID), {
      'employeeList': FieldValue.arrayRemove([employeeID]),
    });
    await batch.commit();
  }

  Future<void> deleteEmployee(String employeeID) async {
    await db.collection('employees').doc(employeeID).delete();
  }

  // Projects

  Future<ProjectModel?> getProject(String projectID) async {
    final doc = await db.collection('projects').doc(projectID).get();
    if (!doc.exists) return null;
    return ProjectModel.fromMap(doc.data()!);
  }

  Future<void> addMediaFileToProject(String projectID, String url) async {
    await db.collection('projects').doc(projectID).update({
      'mediaFiles': FieldValue.arrayUnion([url]),
    });
  }

  // Community Feed

  Future<void> createPost(PostModel post) async {
    final batch = db.batch();
    batch.set(db.collection('posts').doc(post.postID), post.toMap());
    if (post.authorType != 'Company') {
      batch.update(db.collection('jobSeekers').doc(post.authorID), {
        'postList': FieldValue.arrayUnion([post.postID]),
      });
    }
    await batch.commit();
  }

  Future<void> editPost(String postID, Map<String, dynamic> newData) async {
    await db.collection('posts').doc(postID).update(newData);
  }

  Future<void> deletePost(String postID) async {
    await db.collection('posts').doc(postID).delete();
  }

  Future<List<PostModel>> getFeed(String userID) async {
    final seeker = await getJobSeeker(userID);
    final following = seeker?.following ?? [];
    if (following.isEmpty) return [];

    final results = <PostModel>[];
    for (int i = 0; i < following.length; i += 10) {
      final chunk = following.sublist(
        i,
        i + 10 > following.length ? following.length : i + 10,
      );
      final snap = await db
          .collection('posts')
          .where('authorID', whereIn: chunk)
          .orderBy('createdAt', descending: true)
          .get();
      results.addAll(snap.docs.map((d) => PostModel.fromMap(d.data())));
    }
    results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return results;
  }

  Future<List<PostModel>> getPostsByAuthor(String authorID) async {
    final snap = await db
        .collection('posts')
        .where('authorID', isEqualTo: authorID)
        .get();
    final posts = snap.docs.map((d) => PostModel.fromMap(d.data())).toList();
    posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return posts;
  }

  // Explore feed: every company's posts + posts from job seekers the
  // current user follows + the current user's own posts.
  Future<List<PostModel>> getCommunityFeed(String userID) async {
    final seeker = await getJobSeeker(userID);
    final following = <String>{...(seeker?.following ?? []), userID}.toList();

    final companySnap = await db
        .collection('posts')
        .where('authorType', isEqualTo: 'Company')
        .get();
    final posts = companySnap.docs
        .map((d) => PostModel.fromMap(d.data()))
        .toList();

    for (int i = 0; i < following.length; i += 10) {
      final chunk = following.sublist(
        i,
        i + 10 > following.length ? following.length : i + 10,
      );
      final snap = await db
          .collection('posts')
          .where('authorID', whereIn: chunk)
          .where('authorType', isEqualTo: 'JobSeeker')
          .get();
      posts.addAll(snap.docs.map((d) => PostModel.fromMap(d.data())));
    }

    posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return posts;
  }

  // Followers + following, resolved to raw maps (checks both collections
  // since an ID alone doesn't say if it's a job seeker or a company).
  // Each map has: id, name, subtitle, imageUrl, type.
  // Previously lived in firebase_service_community_extensions.dart —
  // merged in here.
  Future<List<Map<String, String>>> getMyCommunity(String userID) async {
    final seeker = await getJobSeeker(userID);
    final ids = <String>{
      ...(seeker?.followers ?? []),
      ...(seeker?.following ?? []),
    };

    final result = <Map<String, String>>[];
    for (final id in ids) {
      final s = await getJobSeeker(id);
      if (s != null) {
        result.add({
          'id': id,
          'name': s.name,
          'subtitle': s.experienceLevel.isNotEmpty
              ? s.experienceLevel
              : 'Job Seeker',
          'imageUrl': s.profilePic,
          'type': 'JobSeeker',
        });
        continue;
      }
      final c = await getCompany(id);
      if (c != null) {
        result.add({
          'id': id,
          'name': c.companyName,
          'subtitle': c.industry.isNotEmpty ? c.industry : 'Company',
          'imageUrl': c.logo,
          'type': 'Company',
        });
      }
    }
    return result;
  }

  Future<void> deleteUserCompletely(String userID, String userType) async {
    await db.collection('userIndex').doc(userID).delete();

    if (userType == 'JobSeeker') {
      await db.collection('jobSeekers').doc(userID).delete();
    } else if (userType == 'Company') {
      await db.collection('companies').doc(userID).delete();
    } else if (userType == 'Admin') {
      await db.collection('admins').doc(userID).delete();
    }
  }

  Future<void> likePost(String postID, String userID) async {
    final postRef = db.collection('posts').doc(postID);

    await db.runTransaction((transaction) async {
      final doc = await transaction.get(postRef);
      final liked = List<String>.from(doc.data()?['likedByUserIDs'] ?? []);

      if (liked.contains(userID)) {
        transaction.update(postRef, {
          'likes': FieldValue.increment(-1),
          'likedByUserIDs': FieldValue.arrayRemove([userID]),
        });
      } else {
        transaction.update(postRef, {
          'likes': FieldValue.increment(1),
          'likedByUserIDs': FieldValue.arrayUnion([userID]),
        });
      }
    });
  }

  Future<void> addComment(
    String postID,
    String userID,
    String authorName,
    String text,
  ) async {
    final comment = CommentModel(
      commentID: db.collection('comments').doc().id,
      postID: postID,
      authorID: userID,
      authorName: authorName,
      commentText: text,
    );
    await db.collection('comments').doc(comment.commentID).set(comment.toMap());
    await db.collection('posts').doc(postID).update({
      'totalCommentCount': FieldValue.increment(1),
    });
  }

  Future<List<CommentModel>> getComments(String postID) async {
    final snap = await db
        .collection('comments')
        .where('postID', isEqualTo: postID)
        .get();
    final comments = snap.docs
        .map((d) => CommentModel.fromMap(d.data()))
        .toList();
    comments.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return comments;
  }

  Future<List<Map<String, String>>> getFollowRequestsForJobSeeker(
    String jobSeekerID,
  ) async {
    final seeker = await getJobSeeker(jobSeekerID);
    final requestIDs = seeker?.followRequests ?? [];

    final result = <Map<String, String>>[];
    for (final requestID in requestIDs) {
      final request = await getFollowRequest(requestID);
      if (request == null || request.status != 'Pending') continue;

      final fromUser = await getJobSeeker(request.fromID);
      if (fromUser == null) continue;

      result.add({
        'requestID': request.requestID,
        'fromID': request.fromID,
        'name': fromUser.name,
        'imageURL': fromUser.profilePic,
        'shortDescription': fromUser.experienceLevel.isNotEmpty
            ? fromUser.experienceLevel
            : 'Job Seeker',
      });
    }
    return result;
  }

  Future<List<Map<String, String>>> getFollowRequestsForCompany(
    String companyID,
  ) async {
    final company = await getCompany(companyID);
    final requestIDs = company?.followRequests ?? [];

    final result = <Map<String, String>>[];
    for (final requestID in requestIDs) {
      final request = await getFollowRequest(requestID);
      if (request == null || request.status != 'Pending') continue;

      final fromUser = await getJobSeeker(request.fromID);
      if (fromUser == null) continue;

      result.add({
        'requestID': request.requestID,
        'fromID': request.fromID,
        'name': fromUser.name,
        'imageURL': fromUser.profilePic,
        'shortDescription': fromUser.experienceLevel.isNotEmpty
            ? fromUser.experienceLevel
            : 'Job Seeker',
      });
    }
    return result;
  }

  Future<void> deleteComment(String commentID, String postID) async {
    await db.collection('comments').doc(commentID).delete();
    await db.collection('posts').doc(postID).update({
      'totalCommentCount': FieldValue.increment(-1),
    });
  }

  // Career Guidance Task
  Future<List<CareerGuidanceTaskModel>> viewCareerTasks(
    String jobSeekerID,
  ) async {
    final snap = await db
        .collection('careerTasks')
        .where('jobSeekerID', isEqualTo: jobSeekerID)
        .get();
    return snap.docs
        .map((d) => CareerGuidanceTaskModel.fromMap(d.data()))
        .toList();
  }

  Future<List<CareerGuidanceTaskModel>> getPriorityTasks(
    String jobSeekerID,
  ) async {
    final tasks = await viewCareerTasks(jobSeekerID);
    tasks.sort((a, b) {
      const order = {'High': 0, 'Medium': 1, 'Low': 2};
      return (order[a.priority] ?? 1).compareTo(order[b.priority] ?? 1);
    });
    return tasks;
  }

  Future<void> markTaskComplete(String taskID) async {
    await db.collection('careerTasks').doc(taskID).update({
      'isCompleted': true,
      'completedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> deleteTask(String taskID) async {
    await db.collection('careerTasks').doc(taskID).delete();
  }

  // Saves a CareerGuidanceTaskModel (aiGenerated: true, false if hand-created by an admin).
  Future<void> saveCareerTask(CareerGuidanceTaskModel task) async {
    await db.collection('careerTasks').doc(task.taskID).set(task.toMap());
    await db.collection('jobSeekers').doc(task.jobSeekerID).update({
      'careerGuidanceTasks': FieldValue.arrayUnion([task.taskID]),
    });
  }

  // Skill
  Future<void> createNewSkill(SkillModel skill) async {
    await db.collection('skills').doc(skill.skillID).set(skill.toMap());
  }

  Future<void> updateSkill(String skillID, Map<String, dynamic> newData) async {
    await db.collection('skills').doc(skillID).update(newData);
  }

  Future<List<SkillModel>> listAllSkills() async {
    final snap = await db.collection('skills').get();
    return snap.docs.map((d) => SkillModel.fromMap(d.data())).toList();
  }

  Future<SkillModel?> searchSkill(String skillID) async {
    final doc = await db.collection('skills').doc(skillID).get();
    if (!doc.exists) return null;
    return SkillModel.fromMap(doc.data()!);
  }

  Future<List<TestModel>> getRelatedTests(String skillID) async {
    final snap = await db
        .collection('tests')
        .where('skillID', isEqualTo: skillID)
        .get();
    return snap.docs.map((d) => TestModel.fromMap(d.data())).toList();
  }

  Future<CompanyModel?> getCompanyByEmail(String email) async {
    final snap = await db
        .collection('companies')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;
    return CompanyModel.fromMap(snap.docs.first.data());
  }

  Future<BadgeModel?> getEligibleBadgeForScore(double score) async {
    final snap = await db.collection('badges').get();
    final badges = snap.docs.map((d) => BadgeModel.fromMap(d.data())).toList();

    for (final badge in badges) {
      if (badge.checkEligibility(score)) return badge;
    }
    return null;
  }

  // Badge
  Future<void> createNewBadge(BadgeModel badge) async {
    await db.collection('badges').doc(badge.badgeID).set(badge.toMap());
  }

  Future<void> updateBadge(String badgeID, Map<String, dynamic> newData) async {
    await db.collection('badges').doc(badgeID).update(newData);
  }

  Future<void> deleteBadge(String badgeID) async {
    await db.collection('badges').doc(badgeID).delete();
  }

  // Verified skill badge objective — called automatically after a passed
  // test (see evaluateAndSubmitTest below).
  Future<void> awardBadgeToJobSeeker(String badgeID, String jobSeekerID) async {
    await db.collection('jobSeekers').doc(jobSeekerID).update({
      'earnedBadges': FieldValue.arrayUnion([badgeID]),
      'totalBadgesEarned': FieldValue.increment(1),
    });
  }

  // Everyone who has this badge on their earnedBadges list (awarded via
  // awardBadgeToJobSeeker, e.g. after a passed test).
  Future<List<JobSeekerModel>> getEligibleJobSeekers(String badgeID) async {
    final snap = await db
        .collection('jobSeekers')
        .where('earnedBadges', arrayContains: badgeID)
        .get();
    return snap.docs.map((d) => JobSeekerModel.fromMap(d.data())).toList();
  }

  // Test
  Future<void> saveTest(TestModel test) async {
    await db.collection('tests').doc(test.testID).set(test.toMap());
  }

  Future<TestModel?> getTest(String testID) async {
    final doc = await db.collection('tests').doc(testID).get();
    if (!doc.exists) return null;
    return TestModel.fromMap(doc.data()!);
  }

  Future<void> deleteTest(String testID) async {
    await db.collection('tests').doc(testID).delete();
  }

  Future<List<TestModel>> viewAllSkillTests() async {
    final snap = await db.collection('tests').get();
    return snap.docs.map((d) => TestModel.fromMap(d.data())).toList();
  }

  // Result
  Future<ResultModel> evaluateAndSubmitTest({
    required String jobSeekerID,
    required TestModel test,
    required Map<String, String> answers, // questionID -> candidate answer
    required DateTime startedAt,
    Map<String, double> openEndedScores = const {}, // questionID -> 0-100
  }) async {
    double totalMarks = 0;
    double earnedMarks = 0;
    for (final q in test.questions) {
      totalMarks += q.marks;
      final given = answers[q.questionID] ?? '';
      if (q.correctAnswer.isNotEmpty) {
        if (given.trim().toLowerCase() ==
            q.correctAnswer.trim().toLowerCase()) {
          earnedMarks += q.marks;
        }
      } else if (openEndedScores.containsKey(q.questionID)) {
        earnedMarks += (openEndedScores[q.questionID]! / 100) * q.marks;
      }
    }
    final score = totalMarks == 0 ? 0.0 : (earnedMarks / totalMarks) * 100;
    final isPassed = score >= test.passingScore;

    final priorAttempts = await getResultsByJobSeekerAndTest(
      jobSeekerID,
      test.testID,
    );
    final attemptNumber = priorAttempts.length + 1;
    DateTime? cooldownUntil;
    if (!isPassed && attemptNumber >= 2) {
      cooldownUntil = DateTime.now().add(const Duration(days: 30));
    }

    String? badgeEarned;
    if (isPassed) {
      final badge = await getEligibleBadgeForScore(score);
      if (badge != null) {
        badgeEarned = badge.badgeID;
        await awardBadgeToJobSeeker(badge.badgeID, jobSeekerID);
      }
    }

    final result = ResultModel(
      resultID: db.collection('results').doc().id,
      jobSeekerID: jobSeekerID,
      testID: test.testID,
      score: score,
      isPassed: isPassed,
      startedAt: startedAt,
      completedAt: DateTime.now(),
      timeTakenSeconds: DateTime.now().difference(startedAt).inSeconds,
      attemptNumber: attemptNumber,
      cooldownUntil: cooldownUntil,
      badgeEarned: badgeEarned,
    );
    await db.collection('results').doc(result.resultID).set(result.toMap());
    await db.collection('jobSeekers').doc(jobSeekerID).update({
      'mySkillTestsResultList': FieldValue.arrayUnion([result.resultID]),
      'totalTestsTaken': FieldValue.increment(1),
      if (isPassed) 'passedResultIDs': FieldValue.arrayUnion([result.resultID]),
    });
    return result;
  }

  Future<ResultModel?> getDetailedResult(String resultID) async {
    final doc = await db.collection('results').doc(resultID).get();
    if (!doc.exists) return null;
    return ResultModel.fromMap(doc.data()!);
  }

  Future<List<ResultModel>> getResultsByJobSeekerAndTest(
    String jobSeekerID,
    String testID,
  ) async {
    final snap = await db
        .collection('results')
        .where('jobSeekerID', isEqualTo: jobSeekerID)
        .where('testID', isEqualTo: testID)
        .get();
    return snap.docs.map((d) => ResultModel.fromMap(d.data())).toList();
  }

  Future<List<ResultModel>> getTestHistory(String jobSeekerID) async {
    final snap = await db
        .collection('results')
        .where('jobSeekerID', isEqualTo: jobSeekerID)
        .get();
    return snap.docs.map((d) => ResultModel.fromMap(d.data())).toList();
  }

  Future<bool> canRetake(String jobSeekerID, String testID) async {
    final attempts = await getResultsByJobSeekerAndTest(jobSeekerID, testID);
    if (attempts.isEmpty) return true;
    attempts.sort((a, b) => b.lastAttemptAt.compareTo(a.lastAttemptAt));
    return attempts.first.isRetakeAllowedNow;
  }

  // Follow Request
  Future<void> saveFollowRequest(FollowRequestModel request) async {
    await db
        .collection('followRequests')
        .doc(request.requestID)
        .set(request.toMap());
  }

  Future<FollowRequestModel?> getFollowRequest(String requestID) async {
    final doc = await db.collection('followRequests').doc(requestID).get();
    if (!doc.exists) return null;
    return FollowRequestModel.fromMap(doc.data()!);
  }

  Future<void> acceptFollowRequest(String requestID) async {
    await db.collection('followRequests').doc(requestID).update({
      'status': 'Accepted',
    });
  }

  Future<void> rejectFollowRequest(String requestID) async {
    await db.collection('followRequests').doc(requestID).update({
      'status': 'Rejected',
    });
  }

  // Job Post
  Future<void> postJob(JobPostModel job) async {
    final batch = db.batch();
    batch.set(db.collection('jobs').doc(job.jobID), job.toMap());
    batch.update(db.collection('companies').doc(job.companyID), {
      'postedJobs': FieldValue.arrayUnion([job.jobID]),
      'activeJobs': FieldValue.increment(1),
    });
    await batch.commit();
  }

  Future<void> editJob(String jobID, Map<String, dynamic> newData) async {
    await db.collection('jobs').doc(jobID).update(newData);
  }

  Future<void> deleteJob(String jobID) async {
    final job = await getJobPost(jobID);
    if (job == null) return;

    final batch = db.batch();
    batch.delete(db.collection('jobs').doc(jobID));
    batch.update(db.collection('companies').doc(job.companyID), {
      'postedJobs': FieldValue.arrayRemove([jobID]),
      if (!job.isClosed) 'activeJobs': FieldValue.increment(-1),
    });
    await batch.commit();
  }

  // closeJob — now needs companyID to update the counter
  Future<void> closeJob(String jobID) async {
    final job = await getJobPost(jobID);
    if (job == null || job.isClosed) return; // already closed, nothing to do

    final batch = db.batch();
    batch.update(db.collection('jobs').doc(jobID), {'isClosed': true});
    batch.update(db.collection('companies').doc(job.companyID), {
      'activeJobs': FieldValue.increment(-1),
    });
    await batch.commit();
  }

  Future<JobPostModel?> getJobPost(String jobID) async {
    final doc = await db.collection('jobs').doc(jobID).get();
    if (!doc.exists) return null;
    return JobPostModel.fromMap(doc.data()!);
  }

  Future<List<JobPostModel>> getJobsByCompany(String companyID) async {
    final snap = await db
        .collection('jobs')
        .where('companyID', isEqualTo: companyID)
        .get();
    return snap.docs.map((d) => JobPostModel.fromMap(d.data())).toList();
  }

  Future<List<JobPostModel>> viewAllJobs() async {
    final snap = await db.collection('jobs').get();
    return snap.docs.map((d) => JobPostModel.fromMap(d.data())).toList();
  }

  // Search across internal + external jobs, matches JobSeeker.searchJobs(filters).
  Future<List<JobPostModel>> searchJobs({
    String? skill,
    String? location,
    String? jobType,
  }) async {
    Query<Map<String, dynamic>> q = db.collection('jobs');
    if (location != null && location.isNotEmpty) {
      q = q.where('location', isEqualTo: location);
    }
    if (jobType != null && jobType.isNotEmpty) {
      q = q.where('jobType', isEqualTo: jobType);
    }
    final snap = await q.get();
    var jobs = snap.docs.map((d) => JobPostModel.fromMap(d.data())).toList();
    if (skill != null && skill.isNotEmpty) {
      jobs = jobs.where((j) => j.requiredSkills.contains(skill)).toList();
    }
    return jobs;
  }

  Future<void> saveExternalJobs(List<JobPostModel> externalJobs) async {
    final batch = db.batch();
    for (final job in externalJobs) {
      batch.set(db.collection('jobs').doc(job.jobID), job.toMap());
    }
    await batch.commit();
  }

  Future<List<JobSeekerModel>> filterCandidates({
    required List<String> requiredSkillIDs,
    String? experienceLevel,
  }) async {
    final all = await listAllJobSeekers();
    final matches = <JobSeekerModel>[];

    // Cache test lookups so repeated testIDs across seekers/results don't
    // trigger duplicate Firestore reads.
    final testCache = <String, TestModel?>{};
    Future<TestModel?> cachedGetTest(String testID) async {
      if (testCache.containsKey(testID)) return testCache[testID];
      final test = await getTest(testID);
      testCache[testID] = test;
      return test;
    }

    for (final seeker in all) {
      final levelOk =
          experienceLevel == null || seeker.experienceLevel == experienceLevel;
      if (!levelOk) continue;

      if (requiredSkillIDs.isEmpty) {
        matches.add(seeker);
        continue;
      }

      final passedSkillIDs = <String>{};
      for (final resultID in seeker.passedResultIDs) {
        final result = await getDetailedResult(resultID);
        if (result == null) continue;
        final test = await cachedGetTest(result.testID);
        if (test != null) passedSkillIDs.add(test.skillID);
      }

      final skillsOk = requiredSkillIDs.every(passedSkillIDs.contains);
      if (skillsOk) matches.add(seeker);
    }

    return matches;
  }

  Future<List<JobPostModel>> getJobsByFollowedCompanies(
    List<String> companyIDs,
  ) async {
    if (companyIDs.isEmpty) return [];
    final results = <JobPostModel>[];
    for (int i = 0; i < companyIDs.length; i += 10) {
      final chunk = companyIDs.sublist(
        i,
        i + 10 > companyIDs.length ? companyIDs.length : i + 10,
      );
      final snap = await db
          .collection('jobs')
          .where('companyID', whereIn: chunk)
          .get();
      results.addAll(snap.docs.map((d) => JobPostModel.fromMap(d.data())));
    }
    return results;
  }

  Future<ApplicationModel> applyJob({
    required String jobSeekerID,
    required String jobID,
    String coldEmail = '',
    String resumeUrl = '',
  }) async {
    final job = await getJobPost(jobID);
    final seeker = await getJobSeeker(jobSeekerID);
    if (job == null || seeker == null) {
      throw Exception('Job or job seeker not found.');
    }

    final existing = await db
        .collection('applications')
        .where('jobID', isEqualTo: jobID)
        .where('jobSeekerID', isEqualTo: jobSeekerID)
        .limit(1)
        .get();
    if (existing.docs.isNotEmpty) {
      throw Exception('You have already applied to this job.');
    }

    final application = ApplicationModel(
      applicationID: db.collection('applications').doc().id,
      jobID: jobID,
      jobSeekerID: jobSeekerID,
      companyID: job.companyID,
      coldEmail: coldEmail,
      resumeUrl: resumeUrl,
    );

    final batch = db.batch();
    batch.set(
      db.collection('applications').doc(application.applicationID),
      application.toMap(),
    );
    batch.update(db.collection('jobs').doc(jobID), {
      'applicants': FieldValue.arrayUnion([application.applicationID]),
    });
    batch.update(db.collection('jobSeekers').doc(jobSeekerID), {
      'appliedJobRequests': FieldValue.arrayUnion([application.applicationID]),
    });
    batch.update(db.collection('companies').doc(job.companyID), {
      'receivedApplications': FieldValue.arrayUnion([
        application.applicationID,
      ]),
    });
    await batch.commit();

    return application;
  }

  Future<void> updateApplicationStatus(
    String applicationID,
    String status,
  ) async {
    await db.collection('applications').doc(applicationID).update({
      'status': status,
    });
  }

  Future<ApplicationModel?> getApplication(String applicationID) async {
    final doc = await db.collection('applications').doc(applicationID).get();
    if (!doc.exists) return null;
    return ApplicationModel.fromMap(doc.data()!);
  }

  Future<List<ApplicationModel>> getApplicationsByJob(String jobID) async {
    final snap = await db
        .collection('applications')
        .where('jobID', isEqualTo: jobID)
        .get();
    return snap.docs.map((d) => ApplicationModel.fromMap(d.data())).toList();
  }

  Future<List<ApplicationModel>> getApplicationsByJobSeeker(
    String jobSeekerID,
  ) async {
    final snap = await db
        .collection('applications')
        .where('jobSeekerID', isEqualTo: jobSeekerID)
        .get();
    return snap.docs.map((d) => ApplicationModel.fromMap(d.data())).toList();
  }

  Future<List<BadgeModel>> listAllBadges() async {
    final snap = await db.collection('badges').get();
    return snap.docs.map((d) => BadgeModel.fromMap(d.data())).toList();
  }

  Future<JobSeekerModel?> getJobSeekerByEmail(String email) async {
    final snap = await db
        .collection('jobSeekers')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;
    return JobSeekerModel.fromMap(snap.docs.first.data());
  }

  static String tierForScore(double score) {
    if (score >= 90) return 'Gold';
    if (score >= 75) return 'Silver';
    if (score >= 50) return 'Bronze';
    return 'None';
  }

  static String jobExperienceTier(String experienceLevel) {
    final level = experienceLevel.toLowerCase();

    // Gold: 5+ years, Senior, Lead
    if (level.contains('5+') ||
        level.contains('5 to onward') ||
        level.contains('5 years+') ||
        level.contains('senior') ||
        level.contains('lead')) {
      return 'Gold';
    }

    // Silver: 1-5 years, Intermediate
    if (level.contains('1 to 5') ||
        level.contains('1-5') ||
        level.contains('intermediate')) {
      return 'Silver';
    }

    // Bronze: Internship, 0 years, Fresher, Entry Level
    if (level.contains('intern') ||
        level.contains('0 year') ||
        level.contains('fresher') ||
        level.contains('entry level') ||
        level.contains('entry-level') ||
        level.contains('junior')) {
      return 'Bronze';
    }

    // Default fallback to Bronze for unrecognized levels
    return 'Bronze';
  }

  static List<String> eligibleJobTiersFor(String skillTier) {
    if (skillTier == 'Gold') return ['Gold', 'Silver', 'Bronze'];
    if (skillTier == 'Silver') return ['Silver', 'Bronze'];
    if (skillTier == 'Bronze') return ['Bronze'];
    return [];
  }

  Future<Map<String, double>> getBestPassedScoresBySkill(
    String jobSeekerID,
  ) async {
    final allResults = await getTestHistory(jobSeekerID);
    final passedResults = allResults.where((result) => result.isPassed);

    final testCache = <String, TestModel?>{};

    Future<TestModel?> getTestCached(String testID) async {
      if (testCache.containsKey(testID)) return testCache[testID];
      final test = await getTest(testID);
      testCache[testID] = test;
      return test;
    }

    final bestScoreBySkill = <String, double>{};

    for (final result in passedResults) {
      final test = await getTestCached(result.testID);
      if (test == null) continue;

      final currentBest = bestScoreBySkill[test.skillID];
      if (currentBest == null || result.score > currentBest) {
        bestScoreBySkill[test.skillID] = result.score;
      }
    }

    return bestScoreBySkill;
  }

  Future<List<JobPostModel>> getJobsForSkillTier(
    String skillID,
    String skillTier,
  ) async {
    final snap = await db
        .collection('jobs')
        .where('requiredSkills', arrayContains: skillID)
        .where('isClosed', isEqualTo: false)
        .get();

    final allowedJobTiers = eligibleJobTiersFor(skillTier);
    final jobs = snap.docs.map((d) => JobPostModel.fromMap(d.data())).toList();

    return jobs.where((job) {
      final jobTier = jobExperienceTier(job.experienceLevel);
      return allowedJobTiers.contains(jobTier);
    }).toList();
  }

  Future<List<JobPostModel>> getRecommendedJobs(
    String jobSeekerID, {
    int limit = 10,
  }) async {
    final bestScoreBySkill = await getBestPassedScoresBySkill(jobSeekerID);
    if (bestScoreBySkill.isEmpty) return [];

    final seenJobIDs = <String>{};
    final recommendedJobs = <JobPostModel>[];

    for (final entry in bestScoreBySkill.entries) {
      final skillID = entry.key;
      final score = entry.value;
      final tier = tierForScore(score);

      final matchingJobs = await getJobsForSkillTier(skillID, tier);
      for (final job in matchingJobs) {
        if (seenJobIDs.add(job.jobID)) {
          recommendedJobs.add(job);
        }
      }
    }

    recommendedJobs.sort((a, b) => b.postedAt.compareTo(a.postedAt));
    return recommendedJobs.take(limit).toList();
  }

  Future<List<JobPostModel>> getOtherPlatformJobs({
    List<String> excludeJobIDs = const [],
    int limit = 10,
  }) async {
    final snap = await db
        .collection('jobs')
        .where('isExternal', isEqualTo: false)
        .where('isClosed', isEqualTo: false)
        .get();

    final jobs = snap.docs
        .map((d) => JobPostModel.fromMap(d.data()))
        .where((job) => !excludeJobIDs.contains(job.jobID))
        .toList();

    jobs.sort((a, b) => b.postedAt.compareTo(a.postedAt));
    return jobs.take(limit).toList();
  }

  // ─── Projects / Portfolio ──────────────────────────────────────────────────

  static String generateID() =>
      FirebaseFirestore.instance.collection('_').doc().id;

  /// Save a new project and add its ID to the jobSeeker's portfolio array.
  Future<void> saveProject(ProjectModel project) async {
    final batch = db.batch();
    batch.set(
      db.collection('projects').doc(project.projectID),
      project.toMap(),
    );
    batch.update(db.collection('jobSeekers').doc(project.jobSeekerID), {
      'portfolio': FieldValue.arrayUnion([project.projectID]),
    });
    await batch.commit();
  }

  /// Fetch all projects belonging to a job seeker.
  Future<List<ProjectModel>> getProjectsForJobSeeker(String jobSeekerID) async {
    final snap = await db
        .collection('projects')
        .where('jobSeekerID', isEqualTo: jobSeekerID)
        .get();
    return snap.docs.map((d) => ProjectModel.fromMap(d.data())).toList();
  }

  /// Update specific fields of a project document.
  Future<void> updateProject(
    String projectID,
    Map<String, dynamic> data,
  ) async {
    await db.collection('projects').doc(projectID).update(data);
  }

  /// Delete a project and remove it from the jobSeeker's portfolio array.
  Future<void> deleteProject(String projectID, String jobSeekerID) async {
    final batch = db.batch();
    batch.delete(db.collection('projects').doc(projectID));
    batch.update(db.collection('jobSeekers').doc(jobSeekerID), {
      'portfolio': FieldValue.arrayRemove([projectID]),
    });
    await batch.commit();
  }

  // ─── Employees & Reviews ───────────────────────────────────────────────────

  /// Fetch all employments for a given job seeker.
  Future<List<CompanyEmployeeModel>> getEmployeesForJobSeeker(
    String jobSeekerID,
  ) async {
    final snap = await db
        .collection('employees')
        .where('jobSeekerID', isEqualTo: jobSeekerID)
        .get();
    return snap.docs
        .map((d) => CompanyEmployeeModel.fromMap(d.data()))
        .toList();
  }

  /// Check if a job seeker has already submitted a review for a company.
  Future<ReviewModel?> getReviewForSeekerAndCompany(
    String companyID,
    String jobSeekerID,
  ) async {
    final snap = await db
        .collection('reviews')
        .where('companyID', isEqualTo: companyID)
        .where('jobSeekerID', isEqualTo: jobSeekerID)
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    return ReviewModel.fromMap(snap.docs.first.data());
  }

  Future<void> updateAdmin(String adminID, Map<String, dynamic> newData) async {
    await db.collection('admins').doc(adminID).update(newData);
  }

  // Every project across every job seeker — used by admin to browse portfolios
  Future<List<ProjectModel>> listAllProjects() async {
    final snap = await db.collection('projects').get();
    return snap.docs.map((d) => ProjectModel.fromMap(d.data())).toList();
  }

  Future<List<ProjectModel>> searchAllProjectsByTitle(String titleQuery) async {
    final all = await listAllProjects();
    return all
        .where(
          (p) =>
              p.projectTitle.toLowerCase().contains(titleQuery.toLowerCase()),
        )
        .toList();
  }
}
