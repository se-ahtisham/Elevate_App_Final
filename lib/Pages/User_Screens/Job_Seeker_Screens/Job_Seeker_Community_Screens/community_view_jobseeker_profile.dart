import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/user_description.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/user_education.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/user_socialMedia.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/user_work.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_seeker_model.dart';
import 'package:elevate_app/Database/Online_Database/auth_provider.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityViewJobseekerProfile extends ConsumerStatefulWidget {
  final String jobSeekerID;

  const CommunityViewJobseekerProfile({super.key, required this.jobSeekerID});

  @override
  ConsumerState<CommunityViewJobseekerProfile> createState() =>
      CommunityViewJobseekerProfileState();
}

class CommunityViewJobseekerProfileState
    extends ConsumerState<CommunityViewJobseekerProfile> {
  final firebaseService = FirebaseService();

  JobSeekerModel? seeker;
  bool isLoading = true;
  String followStatus = 'None'; // None | Pending | Following
  bool isBusy = false;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    seeker = await firebaseService.getJobSeeker(widget.jobSeekerID);

    final myID = ref.read(authProvider).jobSeeker?.jobSeekerID;
    if (myID != null && myID != widget.jobSeekerID) {
      followStatus = await firebaseService.getFollowStatus(
        myID,
        widget.jobSeekerID,
      );
    }

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  Future<void> onFollowButtonTap() async {
    final myID = ref.read(authProvider).jobSeeker?.jobSeekerID;
    if (myID == null || followStatus == 'Pending') return;

    setState(() => isBusy = true);
    try {
      if (followStatus == 'Following') {
        await firebaseService.unfollowUser(myID, widget.jobSeekerID);
        setState(() => followStatus = 'None');
      } else {
        await firebaseService.followUser(myID, widget.jobSeekerID);
        setState(() => followStatus = 'Pending');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong. Try again.")),
      );
    } finally {
      if (mounted) setState(() => isBusy = false);
    }
  }

  void onMessageTap() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Messaging is coming soon.")));
  }

  void onPortfolioTap() {
    // Portfolio screen not wired yet — button present for now.
  }

  String get followButtonLabel {
    if (isBusy) return "...";
    switch (followStatus) {
      case 'Following':
        return "Unfollow";
      case 'Pending':
        return "Requested";
      default:
        return "Follow";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Colors.black)),
      );
    }

    if (seeker == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text("No profile data found.")),
      );
    }

    final jobSeeker = seeker!;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        height: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const ElevateHeader(
                title: "User Digital Identity",
                subTitle: "Account Control Center",
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 20),
                child: UserDescription(
                  imageURL: jobSeeker.profilePic.isNotEmpty
                      ? jobSeeker.profilePic
                      : 'https://avatars.githubusercontent.com/u/159082885?v=4',
                  name: jobSeeker.name,
                  shortDescription: jobSeeker.about.isNotEmpty
                      ? jobSeeker.about
                      : "No bio added yet.",
                  skills: jobSeeker.skillCount,
                  followers: jobSeeker.followers.length,
                  followings: jobSeeker.following.length,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 40,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButtonGradient(
                        text: followButtonLabel,
                        height: 50,
                        textSize: 14,
                        textWeight: FontWeight.w500,
                        borderRadius: 50,
                        onTap: (isBusy || followStatus == 'Pending')
                            ? null
                            : onFollowButtonTap,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TexxtButton(
                        text: "Message",
                        height: 50,
                        textSize: 14,
                        textColor: Colors.black,
                        textWeight: FontWeight.w500,
                        borderRadius: 50,
                        backgroundColor: Colors.transparent,
                        borderColor: Colors.black,
                        borderWidth: 1,
                        onTap: onMessageTap,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TexxtButton(
                  text: "Portfolio",
                  height: 50,
                  textSize: 14,
                  textColor: Colors.black,
                  textWeight: FontWeight.w500,
                  borderRadius: 50,
                  backgroundColor: Colors.transparent,
                  borderColor: Colors.black,
                  borderWidth: 1,
                  onTap: onPortfolioTap,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: "ABOUT",
                      fontSize: 18,
                      color: ElevateColor.lightgray,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      text: jobSeeker.about.isNotEmpty
                          ? jobSeeker.about
                          : "No description added yet.",
                      fontSize: 13,
                      color: ElevateColor.whitegray,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.justify,
                      lineHeight: 1.3,
                    ),

                    const SizedBox(height: 22),
                    UserSocialmedia(
                      city: jobSeeker.location.isNotEmpty
                          ? jobSeeker.location
                          : "No location added",
                      country: "",
                      email: jobSeeker.email.isNotEmpty
                          ? jobSeeker.email
                          : "No email added",
                      phone: "Not provided",
                    ),

                    const SizedBox(height: 22),
                    Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 240, 240, 240),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color.fromARGB(255, 173, 173, 173),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CustomText(
                              text: "EXPERIENCE",
                              fontSize: 20,
                              color: ElevateColor.lightgray,
                              fontWeight: FontWeight.bold,
                              lineHeight: 1.0,
                            ),
                            const SizedBox(height: 8),
                            CustomText(
                              text: jobSeeker.experienceLevel.isNotEmpty
                                  ? jobSeeker.experienceLevel
                                  : "No experience level added yet.",
                              fontSize: 12,
                              color: ElevateColor.lightgray,
                              fontWeight: FontWeight.w300,
                              lineHeight: 1.0,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),
                    const CustomText(
                      text: "EDUCATION",
                      fontSize: 20,
                      color: ElevateColor.lightgray,
                      fontWeight: FontWeight.bold,
                      lineHeight: 1.0,
                    ),
                    const SizedBox(height: 15),
                    if (jobSeeker.education.isEmpty)
                      const CustomText(
                        text: "No education added yet.",
                        fontSize: 13,
                        color: ElevateColor.whitegray,
                        fontWeight: FontWeight.w400,
                      )
                    else
                      Column(
                        children: [
                          for (final edu in jobSeeker.education) ...[
                            UserEducation(
                              text: edu.title,
                              subText: "${edu.school} — ${edu.year}",
                              iconData: Icons.school_outlined,
                              iconSize: 25,
                            ),
                            const SizedBox(height: 15),
                          ],
                        ],
                      ),

                    const SizedBox(height: 22),
                    const CustomText(
                      text: "WORK",
                      fontSize: 20,
                      color: ElevateColor.lightgray,
                      fontWeight: FontWeight.bold,
                      lineHeight: 1.0,
                    ),
                    const SizedBox(height: 15),
                    if (jobSeeker.jobExperience.isEmpty)
                      const CustomText(
                        text: "No work experience added yet.",
                        fontSize: 13,
                        color: ElevateColor.whitegray,
                        fontWeight: FontWeight.w400,
                      )
                    else
                      Column(
                        children: [
                          for (final exp in jobSeeker.jobExperience) ...[
                            UserWork(
                              title: exp.jobTitle,
                              subtitle: exp.company,
                              iconData: Icons.person_outline,
                              startDate: exp.from,
                              endDate: exp.to.isEmpty ? null : exp.to,
                            ),
                            const SizedBox(height: 15),
                          ],
                        ],
                      ),

                    const SizedBox(height: 30),
                    TexxtButton(
                      text: "Back",
                      height: 50,
                      textSize: 14,
                      textColor: ElevateColor.gray,
                      textWeight: FontWeight.w400,
                      borderRadius: 50,
                      backgroundColor: Colors.transparent,
                      borderColor: ElevateColor.gray,
                      borderWidth: 1,
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}