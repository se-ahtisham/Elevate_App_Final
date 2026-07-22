import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/user_description.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/user_socialMedia.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_model.dart';
import 'package:elevate_app/Database/Online_Database/auth_provider.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityViewCompanyProfile extends ConsumerStatefulWidget {
  final String companyID;

  const CommunityViewCompanyProfile({super.key, required this.companyID});

  @override
  ConsumerState<CommunityViewCompanyProfile> createState() =>
      CommunityViewCompanyProfileState();
}

class CommunityViewCompanyProfileState
    extends ConsumerState<CommunityViewCompanyProfile> {
  final firebaseService = FirebaseService();

  CompanyModel? company;
  bool isLoading = true;
  String followStatus = 'None'; // None | Pending | Following
  bool isBusy = false;

  @override
  void initState() {
    super.initState();
    loadCompany();
  }

  Future<void> loadCompany() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    company = await firebaseService.getCompany(widget.companyID);

    final myID = ref.read(authProvider).jobSeeker?.jobSeekerID;
    if (myID != null) {
      followStatus = await firebaseService.getFollowStatus(
        myID,
        widget.companyID,
      );
    }

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  Future<void> toggleFollow() async {
    final myID = ref.read(authProvider).jobSeeker?.jobSeekerID;
    if (myID == null || followStatus == 'Pending') return;

    final wasFollowing = followStatus == 'Following';

    // Optimistic update — show the new state immediately instead of "...".
    setState(() {
      isBusy = true;
      followStatus = wasFollowing ? 'None' : 'Pending';
    });

    try {
      if (wasFollowing) {
        await firebaseService.unfollowUser(
          myID,
          widget.companyID,
          toCollection: 'companies',
        );
      } else {
        await firebaseService.followUser(
          myID,
          widget.companyID,
          toCollection: 'companies',
        );
      }
    } catch (e) {
      // Revert on failure.
      if (!mounted) return;
      setState(() => followStatus = wasFollowing ? 'Following' : 'None');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong. Try again.")),
      );
    } finally {
      if (mounted) setState(() => isBusy = false);
    }
  }

  void onMessageTap() {
    showDialog(
      context: context,
      builder: (ctx) {
        final TextEditingController controller = TextEditingController();
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 31, 31, 31),
                  Color.fromARGB(255, 65, 65, 65),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CustomText(
                  text: "Send Message",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "Write a message...",
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.black26,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: TexxtButton(
                        onTap: () => Navigator.pop(ctx),
                        text: "Cancel",
                        textSize: 14,
                        textColor: Colors.white,
                        textWeight: FontWeight.w400,
                        backgroundColor: Colors.transparent,
                        borderRadius: 50,
                        borderColor: Colors.white,
                        borderWidth: 1,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Message sent successfully"),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const CustomText(
                          text: "Send",
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String get followButtonLabel {
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

    if (company == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text("No company data found.")),
      );
    }

    final c = company!;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        height: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevateHeader(
                title: "Digital Identity",
                subTitle: "Company",
                titleSize: 30,
                subtitleSize: 15,
                showBackButton: true,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 20),
                child: UserDescription(
                  imageURL: c.logo.isNotEmpty
                      ? c.logo
                      : 'https://mir-s3-cdn-cf.behance.net/projects/404/e87f90243740647.Y3JvcCwxNTM0LDEyMDAsMzQsMA.jpg',
                  name: c.companyName,
                  shortDescription: c.industry.isNotEmpty
                      ? c.industry
                      : "Company",
                  skills: 0,
                  followers: c.followers.length,
                  followings: 0,
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
                            : toggleFollow,
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
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: "ABOUT US",
                      fontSize: 20,
                      color: ElevateColor.lightgray,
                      fontWeight: FontWeight.bold,
                      lineHeight: 1.0,
                    ),
                    const SizedBox(height: 12),
                    CustomText(
                      text: c.description.isNotEmpty
                          ? c.description
                          : "No description provided.",
                      fontSize: 13,
                      color: ElevateColor.whitegray,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.justify,
                      lineHeight: 1.3,
                    ),

                    const SizedBox(height: 22),
                    UserSocialmedia(
                      city: c.location.isNotEmpty
                          ? c.location
                          : "No location added",
                      country: "",
                      email: c.email.isNotEmpty ? c.email : "No email added",
                    ),

                    const SizedBox(height: 30),
                    const CustomText(
                      text: "Company Strengths",
                      fontSize: 20,
                      color: ElevateColor.lightgray,
                      fontWeight: FontWeight.bold,
                      lineHeight: 1.0,
                    ),
                    const SizedBox(height: 8),
                    CustomText(
                      text: c.companyStrengthList.isNotEmpty
                          ? c.companyStrengthList.join(" • ")
                          : "No strengths added yet.",
                      fontSize: 12,
                      color: ElevateColor.lightgray,
                      fontWeight: FontWeight.w400,
                      lineHeight: 1.2,
                    ),

                    const SizedBox(height: 30),
                    const CustomText(
                      text: "Company Weaknesses",
                      fontSize: 20,
                      color: ElevateColor.lightgray,
                      fontWeight: FontWeight.bold,
                      lineHeight: 1.0,
                    ),
                    const SizedBox(height: 8),
                    CustomText(
                      text: c.companyWeaknessList.isNotEmpty
                          ? c.companyWeaknessList.join(" • ")
                          : "No weaknesses added yet.",
                      fontSize: 12,
                      color: ElevateColor.lightgray,
                      fontWeight: FontWeight.w400,
                      lineHeight: 1.2,
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