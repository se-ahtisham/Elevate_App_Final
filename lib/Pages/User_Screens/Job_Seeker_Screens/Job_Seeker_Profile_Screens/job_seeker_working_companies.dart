import 'package:elevate_app/Animation/slide_left_route.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_employee_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_model.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Profile_Screens/company_review_screen.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JobSeekerWorkingCompanies extends StatefulWidget {
  final String jobSeekerID;

  const JobSeekerWorkingCompanies({super.key, required this.jobSeekerID});

  @override
  State<JobSeekerWorkingCompanies> createState() =>
      _JobSeekerWorkingCompaniesState();
}

class _JobSeekerWorkingCompaniesState
    extends State<JobSeekerWorkingCompanies> {
  final firebaseService = FirebaseService();

  List<CompanyEmployeeModel> myEmployments = [];
  Map<String, CompanyModel> companiesByID = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadEmployments();
  }

  Future<void> loadEmployments() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      final seeker = await firebaseService.getJobSeeker(widget.jobSeekerID);
      final employments =
          await firebaseService.getEmployeesForJobSeeker(widget.jobSeekerID);
      final companies = await firebaseService.listAllCompanies();
      final map = {for (final c in companies) c.companyID: c};

      // Also process manual job experiences/internships from the job seeker profile
      final List<CompanyEmployeeModel> combined = List.from(employments);
      
      if (seeker != null) {
        for (final exp in seeker.jobExperience) {
          // Check if this manual company already exists in employments to avoid duplicates
          final alreadyPresent = employments.any((emp) {
            final compName = map[emp.companyID]?.companyName ?? '';
            return compName.toLowerCase() == exp.company.toLowerCase();
          });
          if (alreadyPresent) continue;

          // Find if the manually added company name matches any platform company
          final matchedCompany = companies.firstWhere(
            (c) => c.companyName.toLowerCase() == exp.company.toLowerCase(),
            orElse: () => CompanyModel(companyID: '', companyName: exp.company),
          );

          combined.add(
            CompanyEmployeeModel(
              employeeID: 'manual_${exp.company}_${exp.jobTitle}',
              jobSeekerID: widget.jobSeekerID,
              companyID: matchedCompany.companyID, // Empty if not a registered company
              position: exp.jobTitle,
              employeeStatus: 'Terminated', // Treated as past experience
            ),
          );
        }
      }

      if (!mounted) return;
      setState(() {
        myEmployments = combined;
        companiesByID = map;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // ── Header ──────────────────────────────────────────
            ElevateHeader(
              title: "Working Companies",
              subTitle: "Your employment history & experiences",
              titleSize: 25,
              subtitleSize: 14,
              showBackButton: true,
            ),

            // ── Body ────────────────────────────────────────────
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    )
                  : myEmployments.isEmpty
                      ? _buildEmpty()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          itemCount: myEmployments.length,
                          itemBuilder: (context, index) {
                            final emp = myEmployments[index];
                            final isManual = emp.employeeID.startsWith('manual_');
                            final company = emp.companyID.isNotEmpty 
                                ? companiesByID[emp.companyID] 
                                : CompanyModel(companyID: '', companyName: emp.employeeID.split('_')[1]);
                            return _CompanyEmploymentCard(
                              emp: emp,
                              company: company,
                              isManual: isManual,
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF0F0F0),
            ),
            child: const Icon(
              Icons.business_outlined,
              size: 44,
              color: Color(0xFF9E9E9E),
            ),
          ),
          const SizedBox(height: 20),
          const CustomText(
            text: "No companies yet",
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ElevateColor.lightgray,
          ),
          const SizedBox(height: 8),
          const CustomText(
            text: "You haven't been added to any company\nor added any work experience.",
            fontSize: 13,
            color: ElevateColor.whitegray,
            textAlign: TextAlign.center,
            lineHeight: 1.6,
          ),
        ],
      ),
    );
  }
}

// ── Per-Company Card ─────────────────────────────────────────────
class _CompanyEmploymentCard extends StatelessWidget {
  final CompanyEmployeeModel emp;
  final CompanyModel? company;
  final bool isManual;

  const _CompanyEmploymentCard({required this.emp, this.company, this.isManual = false});

  @override
  Widget build(BuildContext context) {
    final bool isActive = emp.employeeStatus == 'Active';
    final String companyName = company?.companyName ?? 'Company';
    final String companyEmail = company?.email ?? '';
    final String industry = company?.industry ?? '';
    final String location = company?.location ?? '';
    final String logoUrl = company?.logo ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color.fromARGB(255, 220, 220, 220),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Company Logo ─────────────────────────────────
            _buildLogo(logoUrl),
            const SizedBox(width: 14),

            // ── Info ─────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: companyName,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: ElevateColor.gray,
                    lineHeight: 1.2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  CustomText(
                    text: emp.position.isNotEmpty
                        ? emp.position
                        : 'Employee',
                    fontSize: 12,
                    color: ElevateColor.whitegray,
                    fontWeight: FontWeight.w500,
                    lineHeight: 1.3,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (industry.isNotEmpty || location.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (industry.isNotEmpty)
                          Flexible(child: _InfoChip(label: industry)),
                        if (industry.isNotEmpty && location.isNotEmpty)
                          const SizedBox(width: 6),
                        if (location.isNotEmpty)
                          Flexible(
                            child: _InfoChip(
                              label: location,
                              icon: Icons.location_on_outlined,
                            ),
                          ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),

                  // ── Status badge ─────────────────────────
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFFE8F5E9)
                              : const Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isActive
                                    ? const Color(0xFF43A047)
                                    : const Color(0xFFBDBDBD),
                              ),
                            ),
                            const SizedBox(width: 5),
                            CustomText(
                              text: isActive ? 'Current' : 'Past',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isActive
                                  ? const Color(0xFF388E3C)
                                  : ElevateColor.whitegray,
                              lineHeight: 1.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),


            // ── Arrow → Review ────────────────────────────────
            emp.companyID.isEmpty
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const CustomText(
                      text: "Offline",
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        SlideLeftRoute(
                          page: CompanyReviewScreen(
                            companyID: emp.companyID,
                            companyName: companyName,
                            companyEmail: companyEmail,
                            jobSeekerID: emp.jobSeekerID,
                            logoPath: logoUrl,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: ElevateColor.gray,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(String url) {
    final Widget fallback = Container(
      width: 54,
      height: 54,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFE8E8E8),
      ),
      child: const Icon(
        Icons.business_outlined,
        size: 26,
        color: Colors.black54,
      ),
    );

    if (url.isEmpty) return fallback;

    return ClipOval(
      child: url.startsWith('http')
          ? Image.network(
              url,
              width: 54,
              height: 54,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => fallback,
            )
          : Image.asset(
              url,
              width: 54,
              height: 54,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => fallback,
            ),
    );
  }
}

// ── Small label chip ─────────────────────────────────────────────
class _InfoChip extends StatelessWidget {
  final String label;
  final IconData? icon;

  const _InfoChip({required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 11, color: ElevateColor.whitegray),
          const SizedBox(width: 2),
        ],
        Flexible(
          child: CustomText(
            text: label,
            fontSize: 11,
            color: ElevateColor.whitegray,
            lineHeight: 1.0,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}