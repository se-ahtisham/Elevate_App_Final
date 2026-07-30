import 'package:elevate_app/Custom_Widgets/Tiles/job_black_tile.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_post_model.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Pages/User_Screens/Company_Screens/Company_Posts_Screens/show_applied_candidates_screen.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class CompanyJobDetailScreen extends StatefulWidget {
  final JobPostModel job;
  const CompanyJobDetailScreen({super.key, required this.job});

  @override
  State<CompanyJobDetailScreen> createState() =>
      _CompanyJobDetailScreenState();
}

class _CompanyJobDetailScreenState extends State<CompanyJobDetailScreen> {
  bool isDeleting = false;

  Future<void> _confirmAndDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Delete Job"),
        content: const Text(
          "Are you sure you want to delete this job posting? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      isDeleting = true;
    });

    try {
      await FirebaseService().deleteJob(widget.job.jobID);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Job deleted successfully.")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isDeleting = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to delete job: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Job Details",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: ElevateColor.gray,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              JobBlackTile(
                title: job.title.isNotEmpty ? job.title : "Untitled",
                company: "Company",
                location: job.location.isNotEmpty ? job.location : "Remote",
                description: job.description,
                jobType: job.jobType,
                jobMode: "Full Time",
                salary: job.salary,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle("Description"),
                      const SizedBox(height: 8),
                      Text(
                        job.description.isNotEmpty
                            ? job.description
                            : "No description provided.",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4D4D4D),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _sectionTitle("Experience Level"),
                      const SizedBox(height: 8),
                      Text(
                        job.experienceLevel.isNotEmpty
                            ? job.experienceLevel
                            : "Not specified",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4D4D4D),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _sectionTitle("Applicants"),
                      const SizedBox(height: 8),
                      Text(
                        "${job.applicants.length} applicant(s)",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4D4D4D),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _sectionTitle("Status"),
                      const SizedBox(height: 8),
                      Text(
                        job.isClosed ? "Closed" : "Active",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: job.isClosed
                              ? Colors.red
                              : const Color(0xFF2E8B57),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextButtonGradient(
                text: "VIEW APPLICANTS",
                height: 50,
                textSize: 14,
                textWeight: FontWeight.w400,
                borderRadius: 50,
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ShowAppliedCandidatesScreen(job: job),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: isDeleting ? null : _confirmAndDelete,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: isDeleting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.red,
                          ),
                        )
                      : const Text(
                          "DELETE JOB",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: ElevateColor.gray,
      ),
    );
  }
}
