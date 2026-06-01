import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/admin_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/badge_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/become_employee_request_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/career_guidance_task_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/comment_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/company_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/employee_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/follow_request_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/job_application_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/job_post_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/job_seeker_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/job_seeker_skill_test_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/portfolio_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/post_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/review_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/skill_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/test_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/user_model.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get _users => _db.collection('users');
  CollectionReference get _admins => _db.collection('admins');
  CollectionReference get _jobSeekers => _db.collection('jobSeekers');
  CollectionReference get _companies => _db.collection('companies');
  CollectionReference get _portfolios => _db.collection('portfolios');
  CollectionReference get _jobPosts => _db.collection('jobPosts');
  CollectionReference get _applications => _db.collection('applications');
  CollectionReference get _skills => _db.collection('skills');
  CollectionReference get _badges => _db.collection('badges');
  CollectionReference get _tests => _db.collection('tests');
  CollectionReference get _testResults => _db.collection('testResults');
  CollectionReference get _careerTasks => _db.collection('careerTasks');
  CollectionReference get _posts => _db.collection('posts');
  CollectionReference get _reviews => _db.collection('reviews');
  CollectionReference get _employees => _db.collection('employees');
  CollectionReference get _followRequests => _db.collection('followRequests');
  CollectionReference get _becomeEmployeeRequests =>
      _db.collection('becomeEmployeeRequests');

  // USER

  Future<void> saveUser(UserModel user) async {
    await _users.doc(user.userID).set(user.toMap());
  }

  Future<UserModel?> getUser(String userID) async {
    final doc = await _users.doc(userID).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  Future<void> updateUser(String userID, Map<String, dynamic> newData) async {
    await _users.doc(userID).update(newData);
  }

  Future<void> deleteUser(String userID) async {
    await _users.doc(userID).delete();
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final query = await _users.where('email', isEqualTo: email).limit(1).get();
    if (query.docs.isEmpty) return null;
    return UserModel.fromMap(query.docs.first.data() as Map<String, dynamic>);
  }

  // ADMIN

  Future<void> saveAdmin(AdminModel admin) async {
    await _admins.doc(admin.userID).set(admin.toMap());
  }

  Future<AdminModel?> getAdmin(String userID) async {
    final doc = await _admins.doc(userID).get();
    if (!doc.exists) return null;
    return AdminModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  Future<void> updateAdmin(String userID, Map<String, dynamic> newData) async {
    await _admins.doc(userID).update(newData);
  }

  Future<void> deleteAdmin(String userID) async {
    await _admins.doc(userID).delete();
  }

  Future<List<AdminModel>> getAllAdmins() async {
    final query = await _admins.get();
    return query.docs
        .map((d) => AdminModel.fromMap(d.data() as Map<String, dynamic>))
        .toList();
  }

  // JOB SEEKER

  Future<void> saveJobSeeker(JobSeekerModel jobSeeker) async {
    await _jobSeekers.doc(jobSeeker.userID).set(jobSeeker.toMap());
  }

  Future<JobSeekerModel?> getJobSeeker(String userID) async {
    final doc = await _jobSeekers.doc(userID).get();
    if (!doc.exists) return null;
    return JobSeekerModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  Future<void> updateJobSeeker(
    String userID,
    Map<String, dynamic> newData,
  ) async {
    await _jobSeekers.doc(userID).update(newData);
  }

  Future<List<JobSeekerModel>> getAllJobSeekers() async {
    final query = await _jobSeekers.get();
    return query.docs
        .map((d) => JobSeekerModel.fromMap(d.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<JobSeekerModel>> searchJobSeekers(String nameQuery) async {
    final query = await _jobSeekers
        .where('name', isGreaterThanOrEqualTo: nameQuery)
        .where('name', isLessThan: '${nameQuery}z')
        .get();
    return query.docs
        .map((d) => JobSeekerModel.fromMap(d.data() as Map<String, dynamic>))
        .toList();
  }

  // COMPANY

  Future<void> saveCompany(CompanyModel company) async {
    await _companies.doc(company.userID).set(company.toMap());
  }

  Future<CompanyModel?> getCompany(String companyID) async {
    final doc = await _companies.doc(companyID).get();
    if (!doc.exists) return null;
    return CompanyModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  Future<void> updateCompany(
    String companyID,
    Map<String, dynamic> newData,
  ) async {
    await _companies.doc(companyID).update(newData);
  }

  Future<void> deleteCompany(String companyID) async {
    await _companies.doc(companyID).delete();
  }

  Future<List<CompanyModel>> getAllCompanies() async {
    final query = await _companies.get();
    return query.docs
        .map((d) => CompanyModel.fromMap(d.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<CompanyModel>> searchCompanies(String nameQuery) async {
    final query = await _companies
        .where('name', isGreaterThanOrEqualTo: nameQuery)
        .where('name', isLessThan: '${nameQuery}z')
        .get();
    return query.docs
        .map((d) => CompanyModel.fromMap(d.data() as Map<String, dynamic>))
        .toList();
  }

  // PORTFOLIO

  Future<void> savePortfolio(PortfolioModel portfolio) async {
    await _portfolios.doc(portfolio.portfolioID).set(portfolio.toMap());
  }

  Future<void> updatePortfolio(
    String portfolioID,
    Map<String, dynamic> newData,
  ) async {
    await _portfolios.doc(portfolioID).update(newData);
  }

  Future<void> deletePortfolio(String portfolioID) async {
    await _portfolios.doc(portfolioID).delete();
  }

  Future<List<PortfolioModel>> getJobSeekerPortfolios(
    String jobSeekerID,
  ) async {
    final query = await _portfolios
        .where('jobSeekerID', isEqualTo: jobSeekerID)
        .get();
    return query.docs
        .map((d) => PortfolioModel.fromMap(d.data() as Map<String, dynamic>))
        .toList();
  }

  // JOB POST

  Future<void> saveJobPost(JobPostModel jobPost) async {
    await _jobPosts.doc(jobPost.jobID).set(jobPost.toMap());
  }

  Future<JobPostModel?> getJobPost(String jobID) async {
    final doc = await _jobPosts.doc(jobID).get();
    if (!doc.exists) return null;
    return JobPostModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  Future<void> updateJobPost(String jobID, Map<String, dynamic> newData) async {
    await _jobPosts.doc(jobID).update(newData);
  }

  Future<void> deleteJobPost(String jobID) async {
    await _jobPosts.doc(jobID).delete();
  }

  Future<List<JobPostModel>> getAllJobs() async {
    final query = await _jobPosts.get();
    return query.docs
        .map((d) => JobPostModel.fromMap(d.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<JobPostModel>> getJobsByCompany(String companyID) async {
    final query = await _jobPosts
        .where('companyID', isEqualTo: companyID)
        .get();
    return query.docs
        .map((d) => JobPostModel.fromMap(d.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<JobPostModel>> getJobsByFollowedCompanies(
    List<String> companyIDs,
  ) async {
    if (companyIDs.isEmpty) return [];
    final query = await _jobPosts.where('companyID', whereIn: companyIDs).get();
    return query.docs
        .map((d) => JobPostModel.fromMap(d.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<JobPostModel>> searchJobs({
    required String titleQuery,
    String? jobType,
    String? experienceLevel,
  }) async {
    Query query = _jobPosts
        .where('title', isGreaterThanOrEqualTo: titleQuery)
        .where('title', isLessThan: '${titleQuery}z');
    if (jobType != null) query = query.where('jobType', isEqualTo: jobType);
    if (experienceLevel != null)
      query = query.where('experienceLevel', isEqualTo: experienceLevel);
    final result = await query.get();
    return result.docs
        .map((d) => JobPostModel.fromMap(d.data() as Map<String, dynamic>))
        .toList();
  }

  // JOB APPLICATION

  Future<void> saveApplication(JobApplicationModel application) async {
    await _applications.doc(application.applicationID).set(application.toMap());
  }

  Future<void> updateApplicationStatus(
    String applicationID,
    String status,
  ) async {
    await _applications.doc(applicationID).update({'status': status});
  }

  Future<List<JobApplicationModel>> getApplicationsByJob(String jobID) async {
    final query = await _applications.where('jobID', isEqualTo: jobID).get();
    return query.docs
        .map(
          (d) => JobApplicationModel.fromMap(d.data() as Map<String, dynamic>),
        )
        .toList();
  }

  Future<List<JobApplicationModel>> getApplicationsByJobSeeker(
    String jobSeekerID,
  ) async {
    final query = await _applications
        .where('jobSeekerID', isEqualTo: jobSeekerID)
        .get();
    return query.docs
        .map(
          (d) => JobApplicationModel.fromMap(d.data() as Map<String, dynamic>),
        )
        .toList();
  }

  // SKILL

  Future<void> saveSkill(SkillModel skill) async {
    await _skills.doc(skill.skillID).set(skill.toMap());
  }

  Future<SkillModel?> getSkill(String skillID) async {
    final doc = await _skills.doc(skillID).get();
    if (!doc.exists) return null;
    return SkillModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  Future<List<SkillModel>> getAllSkills() async {
    final query = await _skills.get();
    return query.docs
        .map((d) => SkillModel.fromMap(d.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateSkill(String skillID, Map<String, dynamic> newData) async {
    await _skills.doc(skillID).update(newData);
  }

  Future<void> deleteSkill(String skillID) async {
    await _skills.doc(skillID).delete();
  }

  // BADGE

  Future<void> saveBadge(BadgeModel badge) async {
    await _badges.doc(badge.badgeID).set(badge.toMap());
  }

  Future<List<BadgeModel>> getAllBadges() async {
    final query = await _badges.get();
    return query.docs
        .map((d) => BadgeModel.fromMap(d.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateBadge(String badgeID, Map<String, dynamic> newData) async {
    await _badges.doc(badgeID).update(newData);
  }

  Future<void> deleteBadge(String badgeID) async {
    await _badges.doc(badgeID).delete();
  }

  // TEST

  Future<void> saveTest(TestModel test) async {
    await _tests.doc(test.testID).set(test.toMap());
  }

  Future<TestModel?> getTest(String testID) async {
    final doc = await _tests.doc(testID).get();
    if (!doc.exists) return null;
    return TestModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  Future<List<TestModel>> getAllTests() async {
    final query = await _tests.get();
    return query.docs
        .map((d) => TestModel.fromMap(d.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateTest(String testID, Map<String, dynamic> newData) async {
    await _tests.doc(testID).update(newData);
  }

  Future<void> deleteTest(String testID) async {
    await _tests.doc(testID).delete();
  }

  Future<List<TestModel>> getTestsBySkill(String skillID) async {
    final query = await _tests.where('skillID', isEqualTo: skillID).get();
    return query.docs
        .map((d) => TestModel.fromMap(d.data() as Map<String, dynamic>))
        .toList();
  }

  // SKILL TEST RESULT

  Future<void> saveSkillTestResult(JobSeekerSkillTestModel result) async {
    await _testResults.doc(result.resultID).set(result.toMap());
  }

  Future<JobSeekerSkillTestModel?> getSkillTestResult(String resultID) async {
    final doc = await _testResults.doc(resultID).get();
    if (!doc.exists) return null;
    return JobSeekerSkillTestModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  Future<List<JobSeekerSkillTestModel>> getAllSkillTestResults() async {
    final query = await _testResults.get();
    return query.docs
        .map(
          (d) =>
              JobSeekerSkillTestModel.fromMap(d.data() as Map<String, dynamic>),
        )
        .toList();
  }

  Future<List<JobSeekerSkillTestModel>> getResultsByJobSeeker(
    String jobSeekerID,
  ) async {
    final query = await _testResults
        .where('jobSeekerID', isEqualTo: jobSeekerID)
        .get();
    return query.docs
        .map(
          (d) =>
              JobSeekerSkillTestModel.fromMap(d.data() as Map<String, dynamic>),
        )
        .toList();
  }

  // CAREER GUIDANCE TASK

  Future<void> saveCareerTask(CareerGuidanceTaskModel task) async {
    await _careerTasks.doc(task.taskID).set(task.toMap());
  }

  Future<void> deleteCareerTask(String taskID) async {
    await _careerTasks.doc(taskID).delete();
  }

  Future<List<CareerGuidanceTaskModel>> getCareerTasks(
    String jobSeekerID,
  ) async {
    final query = await _careerTasks
        .where('jobSeekerID', isEqualTo: jobSeekerID)
        .get();
    return query.docs
        .map(
          (d) =>
              CareerGuidanceTaskModel.fromMap(d.data() as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> markCareerTaskComplete(String taskID) async {
    await _careerTasks.doc(taskID).update({
      'isComplete': true,
      'completedAt': FieldValue.serverTimestamp(),
    });
  }

  // POST

  Future<void> savePost(PostModel post) async {
    await _posts.doc(post.postID).set(post.toMap());
  }

  Future<void> deletePost(String postID) async {
    await _posts.doc(postID).delete();
  }

  Future<List<PostModel>> getAllPosts() async {
    final query = await _posts.orderBy('createdAt', descending: true).get();
    return query.docs
        .map((d) => PostModel.fromMap(d.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> likePost(String postID) async {
    await _posts.doc(postID).update({'likes': FieldValue.increment(1)});
  }

  Future<void> addComment(String postID, CommentModel comment) async {
    await _posts.doc(postID).update({
      'comments': FieldValue.arrayUnion([comment.toMap()]),
    });
  }

  // REVIEW

  Future<void> saveReview(ReviewModel review) async {
    await _reviews.doc(review.reviewID).set(review.toMap());
  }

  Future<List<ReviewModel>> getReviewsByCompany(String companyID) async {
    final query = await _reviews.where('companyID', isEqualTo: companyID).get();
    return query.docs
        .map((d) => ReviewModel.fromMap(d.data() as Map<String, dynamic>))
        .toList();
  }

  // EMPLOYEE

  Future<void> saveEmployee(EmployeeModel employee) async {
    await _employees.doc(employee.employeeID).set(employee.toMap());
  }

  Future<List<EmployeeModel>> getEmployeesByCompany(String companyID) async {
    final query = await _employees
        .where('companyID', isEqualTo: companyID)
        .get();
    return query.docs
        .map((d) => EmployeeModel.fromMap(d.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> terminateEmployee(String employeeID) async {
    await _employees.doc(employeeID).update({
      'isTerminated': true,
      'terminatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteEmployee(String employeeID) async {
    await _employees.doc(employeeID).delete();
  }

  // FOLLOW REQUEST

  Future<void> saveFollowRequest(FollowRequestModel request) async {
    await _followRequests.doc(request.requestID).set(request.toMap());
  }

  Future<void> acceptFollowRequest(String requestID) async {
    await _followRequests.doc(requestID).update({
      'status': 'accepted',
      'acceptedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteFollowRequest(String requestID) async {
    await _followRequests.doc(requestID).delete();
  }

  Future<List<FollowRequestModel>> getFollowRequestsForUser(
    String userID,
  ) async {
    final query = await _followRequests
        .where('receiverID', isEqualTo: userID)
        .where('status', isEqualTo: 'pending')
        .get();
    return query.docs
        .map(
          (d) => FollowRequestModel.fromMap(d.data() as Map<String, dynamic>),
        )
        .toList();
  }

  Future<List<FollowRequestModel>> getSentFollowRequests(String userID) async {
    final query = await _followRequests
        .where('senderID', isEqualTo: userID)
        .get();
    return query.docs
        .map(
          (d) => FollowRequestModel.fromMap(d.data() as Map<String, dynamic>),
        )
        .toList();
  }

  // BECOME EMPLOYEE REQUEST

  Future<void> saveBecomeEmployeeRequest(
    BecomeEmployeeRequestModel request,
  ) async {
    await _becomeEmployeeRequests.doc(request.requestID).set(request.toMap());
  }

  Future<BecomeEmployeeRequestModel?> getBecomeEmployeeRequest(
    String requestID,
  ) async {
    final doc = await _becomeEmployeeRequests.doc(requestID).get();
    if (!doc.exists) return null;
    return BecomeEmployeeRequestModel.fromMap(
      doc.data() as Map<String, dynamic>,
    );
  }

  Future<List<BecomeEmployeeRequestModel>> getBecomeEmployeeRequestsByJobSeeker(
    String jobSeekerID,
  ) async {
    final query = await _becomeEmployeeRequests
        .where('jobSeekerID', isEqualTo: jobSeekerID)
        .get();
    return query.docs
        .map(
          (d) => BecomeEmployeeRequestModel.fromMap(
            d.data() as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<List<BecomeEmployeeRequestModel>> getBecomeEmployeeRequestsByCompany(
    String companyID,
  ) async {
    final query = await _becomeEmployeeRequests
        .where('companyID', isEqualTo: companyID)
        .get();
    return query.docs
        .map(
          (d) => BecomeEmployeeRequestModel.fromMap(
            d.data() as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<void> updateBecomeEmployeeRequestStatus(
    String requestID,
    String status,
  ) async {
    await _becomeEmployeeRequests.doc(requestID).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteBecomeEmployeeRequest(String requestID) async {
    await _becomeEmployeeRequests.doc(requestID).delete();
  }
}
