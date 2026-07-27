import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/icon_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/employee_request_tile.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

import 'package:elevate_app/Database/Online_Database/auth_service.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_seeker_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_employee_model.dart';

class ComapanyEmployeeRequest extends StatefulWidget {
  const ComapanyEmployeeRequest({super.key});

  @override
  State<ComapanyEmployeeRequest> createState() => _ComapanyEmployeeRequestState();
}

class _ComapanyEmployeeRequestState extends State<ComapanyEmployeeRequest> {
  final FirebaseService _firebaseService = FirebaseService();
  final AuthService _authService = AuthService();
  String _searchQuery = '';
  
  late Future<List<Map<String, dynamic>>> _pendingRequestsFuture;

  @override
  void initState() {
    super.initState();
    _pendingRequestsFuture = _fetchPendingRequests();
  }

  void _reloadRequests() {
    setState(() {
      _pendingRequestsFuture = _fetchPendingRequests();
    });
  }

  Future<List<Map<String, dynamic>>> _fetchPendingRequests() async {
    final String companyId = _authService.currentUser?.uid ?? '';
    if (companyId.isEmpty) return [];

    final List<CompanyEmployeeModel> allEmployees = 
        await _firebaseService.getEmployeesByCompany(companyId);

    final List<CompanyEmployeeModel> pendingEmployees = allEmployees
        .where((emp) => emp.employeeStatus == 'Pending')
        .toList();

    List<Map<String, dynamic>> employeeData = [];
    for (var emp in pendingEmployees) {
      final JobSeekerModel? seeker = await _firebaseService.getJobSeeker(emp.jobSeekerID);
      if (seeker != null) {
        if (_searchQuery.isEmpty || seeker.name.toLowerCase().contains(_searchQuery.toLowerCase())) {
          employeeData.add({
            'employeeModel': emp,
            'jobSeeker': seeker,
          });
        }
      }
    }
    return employeeData;
  }
  
  Future<void> _acceptRequest(CompanyEmployeeModel emp) async {
    await _firebaseService.acceptEmployeeRequest(emp.employeeID);
    _reloadRequests();
  }

  Future<void> _rejectRequest(CompanyEmployeeModel emp) async {
    await _firebaseService.rejectEmployeeRequest(emp.employeeID, emp.jobSeekerID, emp.companyID);
    _reloadRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconText(
                text: "Explore Request",
                iconData: Icons.people,
                textWeight: FontWeight.w600,
                iconSize: 25,
                textSize: 17,
              ),
              SizedBox(height: 25),
              CustomSearchBar(
                hintText: "Search requests",
                backgroundColor: ElevateColor.white,
                width: 330,
                height: 50,
                textSize: 15,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                    _pendingRequestsFuture = _fetchPendingRequests();
                  });
                },
              ),
              SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _pendingRequestsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No pending requests found"));
                    }

                    final requests = snapshot.data!;
                    return ListView.builder(
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final data = requests[index];
                        final JobSeekerModel jobSeeker = data['jobSeeker'];
                        final CompanyEmployeeModel employee = data['employeeModel'];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: EmployeeRequestTile(
                            height: 120,
                            width: 330,
                            backgroundColor: ElevateColor.white,
                            borderRadius: 20,
                            imageURL: jobSeeker.profilePic.isNotEmpty
                                ? jobSeeker.profilePic
                                : 'lib/Resources/Images/Profile_Images/default_profile.png',
                            name: jobSeeker.name.isNotEmpty ? jobSeeker.name : 'Unknown User',
                            shortDescription: employee.position,
                            acceptonTap: () => _acceptRequest(employee),
                            rejectonTap: () => _rejectRequest(employee),
                          ),
                        );
                      }
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
