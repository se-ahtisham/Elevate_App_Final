import "package:elevate_app/Animation/slide_left_route.dart";
import "package:elevate_app/Custom_Widgets/Buttons/icon_text_button.dart";
import "package:elevate_app/Custom_Widgets/Header/elevate_header.dart";
import "package:elevate_app/Custom_Widgets/Text/custom_text.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_description.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_education.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_socialMedia.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_work.dart";
import "package:elevate_app/Database/Online_Database/auth_provider.dart";
import "package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Profile_Screens/job_seeker_update_profile.dart";
import "package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart";
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";

class JobSeekerProfileScreen extends ConsumerStatefulWidget {
  const JobSeekerProfileScreen({super.key});

  @override
  ConsumerState<JobSeekerProfileScreen> createState() =>
      _JobSeekerProfileScreenState();
}

class _JobSeekerProfileScreenState
    extends ConsumerState<JobSeekerProfileScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    await ref.read(authProvider.notifier).loadCurrentUser();
    if (!mounted) return;
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Colors.black)),
      );
    }

    final jobSeeker = ref.watch(authProvider).jobSeeker;

    if (jobSeeker == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text("No profile data found.")),
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        height: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const ElevateHeader(
                title: "Your Digital Identity",
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
                  vertical: 30,
                  horizontal: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomText(
                          text: "ABOUT ME",
                          fontSize: 20,
                          color: ElevateColor.lightgray,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.left,
                          lineHeight: 1.0,
                        ),
                        const SizedBox(width: 70),
                        IconTextButton(
                          text: "Update Profile",
                          iconData: Icons.settings,
                          backgroundColor: ElevateColor.white,
                          iconColor: ElevateColor.lightgray,
                          textColor: ElevateColor.gray,
                          textWeight: FontWeight.bold,
                          borderColor: ElevateColor.gray,
                          borderRadius: 50,
                          textSize: 12,
                          height: 50,
                          width: 150,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              SlideLeftRoute(
                                page: const JobSeekerUpdateProfile(),
                              ),
                            );
                            loadUser();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "EXPERIENCE",
                              fontSize: 20,
                              color: ElevateColor.lightgray,
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.left,
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
                              textAlign: TextAlign.left,
                              lineHeight: 1.0,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),
                    CustomText(
                      text: "EDUCATION",
                      fontSize: 20,
                      color: ElevateColor.lightgray,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.left,
                      lineHeight: 1.0,
                    ),
                    const SizedBox(height: 15),
                    if (jobSeeker.education.isEmpty)
                      CustomText(
                        text: "No education added yet.",
                        fontSize: 13,
                        color: ElevateColor.whitegray,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.left,
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
                    CustomText(
                      text: "WORK",
                      fontSize: 20,
                      color: ElevateColor.lightgray,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.left,
                      lineHeight: 1.0,
                    ),
                    const SizedBox(height: 15),
                    if (jobSeeker.jobExperience.isEmpty)
                      CustomText(
                        text: "No work experience added yet.",
                        fontSize: 13,
                        color: ElevateColor.whitegray,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.left,
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
