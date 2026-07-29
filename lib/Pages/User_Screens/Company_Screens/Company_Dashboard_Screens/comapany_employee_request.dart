import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/employee_request_tile.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';

import 'package:elevate_app/Database/Online_Database/auth_service.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_seeker_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_employee_model.dart';

class ComapanyEmployeeRequest extends StatefulWidget {
  const ComapanyEmployeeRequest({super.key});

  @override
  State<ComapanyEmployeeRequest> createState() =>
      _ComapanyEmployeeRequestState();
}

class _ComapanyEmployeeRequestState extends State<ComapanyEmployeeRequest> {
  final FirebaseService _firebaseService = FirebaseService();
  final AuthService _authService = AuthService();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _allRequests = [];
  List<Map<String, dynamic>> _visibleRequests = [];
  bool _isLoading = true;
  final Set<String> _processingIDs = {};

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRequests() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    final String companyId = _authService.currentUser?.uid ?? '';
    if (companyId.isEmpty) {
      if (!mounted) return;
      setState(() {
        _allRequests = [];
        _visibleRequests = [];
        _isLoading = false;
      });
      return;
    }

    try {
      final List<CompanyEmployeeModel> allEmployees = await _firebaseService
          .getEmployeesByCompany(companyId);

      final List<CompanyEmployeeModel> pendingEmployees = allEmployees
          .where((emp) => emp.employeeStatus == 'Pending')
          .toList();

      List<Map<String, dynamic>> employeeData = [];
      for (var emp in pendingEmployees) {
        final JobSeekerModel? seeker = await _firebaseService.getJobSeeker(
          emp.jobSeekerID,
        );
        if (seeker != null) {
          employeeData.add({'employeeModel': emp, 'jobSeeker': seeker});
        }
      }

      if (!mounted) return;
      setState(() {
        _allRequests = employeeData;
        _visibleRequests = _applySearch();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Load employee requests failed: $e");
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error loading requests: $e")));
    }
  }

  List<Map<String, dynamic>> _applySearch() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return _allRequests;
    return _allRequests.where((item) {
      final JobSeekerModel seeker = item['jobSeeker'];
      return seeker.name.toLowerCase().contains(query);
    }).toList();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _visibleRequests = _applySearch();
    });
  }

  Future<void> _respond(CompanyEmployeeModel emp, bool accept) async {
    setState(() => _processingIDs.add(emp.employeeID));

    try {
      if (accept) {
        await _firebaseService.acceptEmployeeRequest(emp.employeeID);
      } else {
        await _firebaseService.rejectEmployeeRequest(
          emp.employeeID,
          emp.jobSeekerID,
          emp.companyID,
        );
      }

      if (!mounted) return;
      setState(() {
        _allRequests.removeWhere(
          (item) =>
              (item['employeeModel'] as CompanyEmployeeModel).employeeID ==
              emp.employeeID,
        );
        _visibleRequests.removeWhere(
          (item) =>
              (item['employeeModel'] as CompanyEmployeeModel).employeeID ==
              emp.employeeID,
        );
        _processingIDs.remove(emp.employeeID);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            accept ? "Employee request accepted" : "Employee request rejected",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _processingIDs.remove(emp.employeeID));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            accept
                ? "Couldn't accept request. Try again."
                : "Couldn't reject request. Try again.",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            ElevateHeader(
              title: "Explore Request",
              subTitle: "Manage incoming employee requests",
              showBackButton: true,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomSearchBar(
                      hintText: "Search requests",
                      backgroundColor: ElevateColor.white,
                      width: 330,
                      height: 50,
                      textSize: 15,
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                    ),
              const SizedBox(height: 10),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.black),
                      )
                    : _visibleRequests.isEmpty
                    ? Center(
                        child: CustomText(
                          text: _allRequests.isEmpty
                              ? "No pending requests found."
                              : "No results found.",
                          fontSize: 14,
                          color: ElevateColor.gray,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadRequests,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: _visibleRequests.length,
                          itemBuilder: (context, index) {
                            final data = _visibleRequests[index];
                            final JobSeekerModel jobSeeker = data['jobSeeker'];
                            final CompanyEmployeeModel employee =
                                data['employeeModel'];
                            final isBusy = _processingIDs.contains(
                              employee.employeeID,
                            );

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: EmployeeRequestTile(
                                height: 120,
                                width: 330,
                                backgroundColor: ElevateColor.white,
                                borderRadius: 20,
                                imageURL: jobSeeker.profilePic.isNotEmpty
                                    ? jobSeeker.profilePic
                                    : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(jobSeeker.name.isNotEmpty ? jobSeeker.name : "User")}&background=random&color=fff&size=128&bold=true',
                                name: jobSeeker.name.isNotEmpty
                                    ? jobSeeker.name
                                    : 'Unknown User',
                                shortDescription: employee.position,
                                acceptonTap: isBusy
                                    ? null
                                    : () => _respond(employee, true),
                                rejectonTap: isBusy
                                    ? null
                                    : () => _respond(employee, false),
                              ),
                            );
                          },
                        ),
                      ),
              ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
