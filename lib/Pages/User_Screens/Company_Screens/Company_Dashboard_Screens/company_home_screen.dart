import 'package:elevate_app/Custom_Widgets/Buttons/circle_icon_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/short_description_round_circle_icon_tile.dart';
import 'package:elevate_app/Pages/User_Screens/Company_Screens/Company_Dashboard_Screens/Company_View_Employee_Profile.dart';
import 'package:elevate_app/Pages/User_Screens/Company_Screens/Company_Dashboard_Screens/comapany_employee_request.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:elevate_app/Database/Online_Database/auth_service.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_seeker_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_employee_model.dart';

class CompanyHomeScreen extends StatefulWidget {
  const CompanyHomeScreen({super.key});

  @override
  State<CompanyHomeScreen> createState() => _CompanyHomeScreenState();
}

class _CompanyHomeScreenState extends State<CompanyHomeScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final AuthService _authService = AuthService();
  String _searchQuery = '';

  Future<List<Map<String, dynamic>>> _fetchActiveEmployees() async {
    final String companyId = _authService.currentUser?.uid ?? '';
    if (companyId.isEmpty) return [];

    final List<CompanyEmployeeModel> allEmployees = 
        await _firebaseService.getEmployeesByCompany(companyId);

    final List<CompanyEmployeeModel> activeEmployees = allEmployees
        .where((emp) => emp.employeeStatus == 'Active')
        .toList();

    List<Map<String, dynamic>> employeeData = [];
    for (var emp in activeEmployees) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 241, 241, 241),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            ElevateHeader(
              title: "Dashboard",
              subTitle: "Manage Employees in one place",
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomSearchBar(
                          hintText: "Search Employee",
                          backgroundColor: ElevateColor.white,
                          width: 270,
                          height: 50,
                          textSize: 15,
                          onChanged: (val) {
                            setState(() {
                              _searchQuery = val;
                            });
                          },
                        ),
                        Expanded(
                          child: CircleIconButton(
                            iconData: Icons.person_add,
                            circleSize: 50,
                            circleColor: ElevateColor.lightgray,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ComapanyEmployeeRequest(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    CustomText(
                      text: "WORKING EMPLOYEE",
                      fontSize: 22,
                      color: ElevateColor.gray,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.left,
                      lineHeight: 1.3,
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: _fetchActiveEmployees(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text("Error: ${snapshot.error}"));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text("No active employees found"));
                          }

                          final employees = snapshot.data!;
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: employees.length,
                            itemBuilder: (context, index) {
                              final data = employees[index];
                              final JobSeekerModel jobSeeker = data['jobSeeker'];
                              final CompanyEmployeeModel employee = data['employeeModel'];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: ShortDescriptionRoundCircleIconTile(
                                  height: 80,
                                  width: 350,
                                  backgroundColor: ElevateColor.white,
                                  borderRadius: 12,
                                  imageURL: jobSeeker.profilePic.isNotEmpty
                                      ? jobSeeker.profilePic
                                      : 'lib/Resources/Images/Profile_Images/default_profile.png',
                                  name: jobSeeker.name.isNotEmpty ? jobSeeker.name : 'Unknown User',
                                  shortDescription: employee.position,
                                  iconData: Icons.arrow_forward,
                                  iconSize: 24,
                                  iconColor: Colors.white,
                                  circleSize: 50,
                                  circleColor: ElevateColor.lightgray,
                                  borderWidth: 2,
                                  borderColor: ElevateColor.lightgray,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CompanyViewEmployeeProfile(
                                              jobSeekerID: jobSeeker.jobSeekerID,
                                              employeeID: employee.employeeID,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
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
