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
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/portfolio_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/post_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/review_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/skill_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Models/test_model.dart';
import 'package:elevate_app/Services/Firebase_Services/firebase_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Firebase_Services/firebase_provider.dart';

final _firebaseService = FirebaseService();

final dbProvider = StateNotifierProvider<DbNotifier, DbState>((ref) {
  return DbNotifier(_firebaseService);
});

class DbState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  final List<JobPostModel> jobPosts;
  final List<JobSeekerModel> jobSeekers;
  final List<CompanyModel> companies;
  final List<SkillModel> skills;
  final List<BadgeModel> badges;
  final List<TestModel> tests;
  final List<PostModel> posts;
  final List<EmployeeModel> employees;
  final List<FollowRequestModel> followRequests;
  final List<JobApplicationModel> applications;
  final List<CareerGuidanceTaskModel> careerTasks;
  final List<PortfolioModel> portfolios;
  final List<ReviewModel> reviews;

  const DbState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    this.jobPosts = const [],
    this.jobSeekers = const [],
    this.companies = const [],
    this.skills = const [],
    this.badges = const [],
    this.tests = const [],
    this.posts = const [],
    this.employees = const [],
    this.followRequests = const [],
    this.applications = const [],
    this.careerTasks = const [],
    this.portfolios = const [],
    this.reviews = const [],
  });

  DbState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    List<JobPostModel>? jobPosts,
    List<JobSeekerModel>? jobSeekers,
    List<CompanyModel>? companies,
    List<SkillModel>? skills,
    List<BadgeModel>? badges,
    List<TestModel>? tests,
    List<PostModel>? posts,
    List<EmployeeModel>? employees,
    List<FollowRequestModel>? followRequests,
    List<JobApplicationModel>? applications,
    List<CareerGuidanceTaskModel>? careerTasks,
    List<PortfolioModel>? portfolios,
    List<ReviewModel>? reviews,
  }) {
    return DbState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
      jobPosts: jobPosts ?? this.jobPosts,
      jobSeekers: jobSeekers ?? this.jobSeekers,
      companies: companies ?? this.companies,
      skills: skills ?? this.skills,
      badges: badges ?? this.badges,
      tests: tests ?? this.tests,
      posts: posts ?? this.posts,
      employees: employees ?? this.employees,
      followRequests: followRequests ?? this.followRequests,
      applications: applications ?? this.applications,
      careerTasks: careerTasks ?? this.careerTasks,
      portfolios: portfolios ?? this.portfolios,
      reviews: reviews ?? this.reviews,
    );
  }

  DbState clearMessages() => copyWith();
}

class DbNotifier extends StateNotifier<DbState> {
  final FirebaseService _db;

  DbNotifier(this._db) : super(const DbState());

  // JOB POSTS

  Future<void> fetchAllJobs() async {
    try {
      state = state.copyWith(isLoading: true);
      final jobs = await _db.getAllJobs();
      state = state.copyWith(isLoading: false, jobPosts: jobs);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> fetchJobsByCompany(String companyID) async {
    try {
      state = state.copyWith(isLoading: true);
      final jobs = await _db.getJobsByCompany(companyID);
      state = state.copyWith(isLoading: false, jobPosts: jobs);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> fetchJobsByFollowedCompanies(List<String> companyIDs) async {
    try {
      state = state.copyWith(isLoading: true);
      final jobs = await _db.getJobsByFollowedCompanies(companyIDs);
      state = state.copyWith(isLoading: false, jobPosts: jobs);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> searchJobs({
    required String titleQuery,
    String? jobType,
    String? experienceLevel,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      final jobs = await _db.searchJobs(
        titleQuery: titleQuery,
        jobType: jobType,
        experienceLevel: experienceLevel,
      );
      state = state.copyWith(isLoading: false, jobPosts: jobs);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> saveJobPost(JobPostModel jobPost) async {
    try {
      state = state.copyWith(isLoading: true);
      await _db.saveJobPost(jobPost);
      await fetchAllJobs();
      state = state.copyWith(isLoading: false, successMessage: 'Job posted successfully.');
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> deleteJobPost(String jobID) async {
    try {
      await _db.deleteJobPost(jobID);
      state = state.copyWith(
        jobPosts: state.jobPosts.where((j) => j.jobID != jobID).toList(),
        successMessage: 'Job deleted.',
      );
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  // APPLICATIONS

  Future<void> fetchApplicationsByJob(String jobID) async {
    try {
      state = state.copyWith(isLoading: true);
      final apps = await _db.getApplicationsByJob(jobID);
      state = state.copyWith(isLoading: false, applications: apps);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> fetchApplicationsByJobSeeker(String jobSeekerID) async {
    try {
      state = state.copyWith(isLoading: true);
      final apps = await _db.getApplicationsByJobSeeker(jobSeekerID);
      state = state.copyWith(isLoading: false, applications: apps);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> saveApplication(JobApplicationModel application) async {
    try {
      state = state.copyWith(isLoading: true);
      await _db.saveApplication(application);
      state = state.copyWith(isLoading: false, successMessage: 'Application submitted.');
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> updateApplicationStatus(String applicationID, String status) async {
    try {
      await _db.updateApplicationStatus(applicationID, status);
      state = state.copyWith(successMessage: 'Status updated.');
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  // COMPANIES

  Future<void> fetchAllCompanies() async {
    try {
      state = state.copyWith(isLoading: true);
      final list = await _db.getAllCompanies();
      state = state.copyWith(isLoading: false, companies: list);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> searchCompanies(String nameQuery) async {
    try {
      state = state.copyWith(isLoading: true);
      final list = await _db.searchCompanies(nameQuery);
      state = state.copyWith(isLoading: false, companies: list);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  // JOB SEEKERS

  Future<void> fetchAllJobSeekers() async {
    try {
      state = state.copyWith(isLoading: true);
      final list = await _db.getAllJobSeekers();
      state = state.copyWith(isLoading: false, jobSeekers: list);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> searchJobSeekers(String nameQuery) async {
    try {
      state = state.copyWith(isLoading: true);
      final list = await _db.searchJobSeekers(nameQuery);
      state = state.copyWith(isLoading: false, jobSeekers: list);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  // SKILLS

  Future<void> fetchAllSkills() async {
    try {
      state = state.copyWith(isLoading: true);
      final list = await _db.getAllSkills();
      state = state.copyWith(isLoading: false, skills: list);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> saveSkill(SkillModel skill) async {
    try {
      await _db.saveSkill(skill);
      await fetchAllSkills();
      state = state.copyWith(successMessage: 'Skill saved.');
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> deleteSkill(String skillID) async {
    try {
      await _db.deleteSkill(skillID);
      state = state.copyWith(
        skills: state.skills.where((s) => s.skillID != skillID).toList(),
        successMessage: 'Skill deleted.',
      );
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  // BADGES

  Future<void> fetchAllBadges() async {
    try {
      state = state.copyWith(isLoading: true);
      final list = await _db.getAllBadges();
      state = state.copyWith(isLoading: false, badges: list);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> saveBadge(BadgeModel badge) async {
    try {
      await _db.saveBadge(badge);
      await fetchAllBadges();
      state = state.copyWith(successMessage: 'Badge saved.');
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> deleteBadge(String badgeID) async {
    try {
      await _db.deleteBadge(badgeID);
      state = state.copyWith(
        badges: state.badges.where((b) => b.badgeID != badgeID).toList(),
        successMessage: 'Badge deleted.',
      );
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  // TESTS

  Future<void> fetchAllTests() async {
    try {
      state = state.copyWith(isLoading: true);
      final list = await _db.getAllTests();
      state = state.copyWith(isLoading: false, tests: list);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> fetchTestsBySkill(String skillID) async {
    try {
      state = state.copyWith(isLoading: true);
      final list = await _db.getTestsBySkill(skillID);
      state = state.copyWith(isLoading: false, tests: list);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> saveTest(TestModel test) async {
    try {
      await _db.saveTest(test);
      await fetchAllTests();
      state = state.copyWith(successMessage: 'Test saved.');
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> deleteTest(String testID) async {
    try {
      await _db.deleteTest(testID);
      state = state.copyWith(
        tests: state.tests.where((t) => t.testID != testID).toList(),
        successMessage: 'Test deleted.',
      );
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  // POSTS

  Future<void> fetchAllPosts() async {
    try {
      state = state.copyWith(isLoading: true);
      final list = await _db.getAllPosts();
      state = state.copyWith(isLoading: false, posts: list);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> savePost(PostModel post) async {
    try {
      await _db.savePost(post);
      await fetchAllPosts();
      state = state.copyWith(successMessage: 'Post published.');
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> deletePost(String postID) async {
    try {
      await _db.deletePost(postID);
      state = state.copyWith(
        posts: state.posts.where((p) => p.postID != postID).toList(),
        successMessage: 'Post deleted.',
      );
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> likePost(String postID) async {
    try {
      await _db.likePost(postID);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> addComment(String postID, CommentModel comment) async {
    try {
      await _db.addComment(postID, comment);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  // REVIEWS

  Future<void> fetchReviewsByCompany(String companyID) async {
    try {
      state = state.copyWith(isLoading: true);
      final list = await _db.getReviewsByCompany(companyID);
      state = state.copyWith(isLoading: false, reviews: list);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> saveReview(ReviewModel review) async {
    try {
      await _db.saveReview(review);
      state = state.copyWith(successMessage: 'Review submitted.');
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  // EMPLOYEES

  Future<void> fetchEmployeesByCompany(String companyID) async {
    try {
      state = state.copyWith(isLoading: true);
      final list = await _db.getEmployeesByCompany(companyID);
      state = state.copyWith(isLoading: false, employees: list);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> saveEmployee(EmployeeModel employee) async {
    try {
      await _db.saveEmployee(employee);
      state = state.copyWith(successMessage: 'Employee added.');
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> terminateEmployee(String employeeID) async {
    try {
      await _db.terminateEmployee(employeeID);
      state = state.copyWith(successMessage: 'Employee terminated.');
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> deleteEmployee(String employeeID) async {
    try {
      await _db.deleteEmployee(employeeID);
      state = state.copyWith(
        employees: state.employees.where((e) => e.employeeID != employeeID).toList(),
        successMessage: 'Employee removed.',
      );
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  // FOLLOW REQUESTS

  Future<void> fetchFollowRequestsForUser(String userID) async {
    try {
      state = state.copyWith(isLoading: true);
      final list = await _db.getFollowRequestsForUser(userID);
      state = state.copyWith(isLoading: false, followRequests: list);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> fetchSentFollowRequests(String userID) async {
    try {
      state = state.copyWith(isLoading: true);
      final list = await _db.getSentFollowRequests(userID);
      state = state.copyWith(isLoading: false, followRequests: list);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> saveFollowRequest(FollowRequestModel request) async {
    try {
      await _db.saveFollowRequest(request);
      state = state.copyWith(successMessage: 'Follow request sent.');
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> acceptFollowRequest(String requestID) async {
    try {
      await _db.acceptFollowRequest(requestID);
      state = state.copyWith(successMessage: 'Follow request accepted.');
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> deleteFollowRequest(String requestID) async {
    try {
      await _db.deleteFollowRequest(requestID);
      state = state.copyWith(
        followRequests: state.followRequests.where((r) => r.requestID != requestID).toList(),
      );
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  // CAREER TASKS

  Future<void> fetchCareerTasks(String jobSeekerID) async {
    try {
      state = state.copyWith(isLoading: true);
      final list = await _db.getCareerTasks(jobSeekerID);
      state = state.copyWith(isLoading: false, careerTasks: list);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> saveCareerTask(CareerGuidanceTaskModel task) async {
    try {
      await _db.saveCareerTask(task);
      state = state.copyWith(successMessage: 'Task added.');
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> markCareerTaskComplete(String taskID) async {
    try {
      await _db.markCareerTaskComplete(taskID);
      state = state.copyWith(successMessage: 'Task marked complete.');
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> deleteCareerTask(String taskID) async {
    try {
      await _db.deleteCareerTask(taskID);
      state = state.copyWith(
        careerTasks: state.careerTasks.where((t) => t.taskID != taskID).toList(),
        successMessage: 'Task deleted.',
      );
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  // PORTFOLIOS

  Future<void> fetchPortfolios(String jobSeekerID) async {
    try {
      state = state.copyWith(isLoading: true);
      final list = await _db.getJobSeekerPortfolios(jobSeekerID);
      state = state.copyWith(isLoading: false, portfolios: list);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> savePortfolio(PortfolioModel portfolio) async {
    try {
      await _db.savePortfolio(portfolio);
      state = state.copyWith(successMessage: 'Portfolio saved.');
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> deletePortfolio(String portfolioID) async {
    try {
      await _db.deletePortfolio(portfolioID);
      state = state.copyWith(
        portfolios: state.portfolios.where((p) => p.portfolioID != portfolioID).toList(),
        successMessage: 'Portfolio deleted.',
      );
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  // BECOME EMPLOYEE REQUESTS

  Future<bool> saveBecomeEmployeeRequest(BecomeEmployeeRequestModel request) async {
    try {
      await _db.saveBecomeEmployeeRequest(request);
      state = state.copyWith(successMessage: 'Request sent.');
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> updateBecomeEmployeeRequestStatus(String requestID, String status) async {
    try {
      await _db.updateBecomeEmployeeRequestStatus(requestID, status);
      state = state.copyWith(successMessage: 'Request updated.');
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> deleteBecomeEmployeeRequest(String requestID) async {
    try {
      await _db.deleteBecomeEmployeeRequest(requestID);
      state = state.copyWith(successMessage: 'Request cancelled.');
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  // HELPERS

  void clearMessages() {
    state = state.clearMessages();
  }
}