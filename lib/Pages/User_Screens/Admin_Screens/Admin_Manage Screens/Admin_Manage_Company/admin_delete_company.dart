import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Message_Box/messageBox.dart';
import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/experience_white_black_full.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_model.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminDeleteCompany extends StatefulWidget {
  const AdminDeleteCompany({super.key});

  @override
  State<AdminDeleteCompany> createState() => _AdminDeleteCompanyState();
}

class _AdminDeleteCompanyState extends State<AdminDeleteCompany> {
  final FirebaseService firebaseService = FirebaseService();
  final TextEditingController searchController = TextEditingController();

  List<CompanyModel> allCompanies = [];
  List<CompanyModel> visibleCompanies = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAllCompanies();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadAllCompanies() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      allCompanies = await firebaseService.listAllCompanies();
      if (!mounted) return;
      setState(() {
        visibleCompanies = allCompanies;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't load companies. Try again.")),
      );
    }
  }

  void onSearchChanged(String query) {
    query = query.toLowerCase();

    setState(() {
      visibleCompanies = allCompanies.where((company) {
        return company.companyName.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> deleteCompany(CompanyModel company) async {
    try {
      await firebaseService.deleteCompany(company.companyID);

      if (!mounted) return;
      setState(() {
        allCompanies.removeWhere((item) => item.companyID == company.companyID);
        visibleCompanies.removeWhere(
          (item) => item.companyID == company.companyID,
        );
      });

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) =>
            Messagebox(message: "${company.companyName} deleted successfully."),
      );
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => const Messagebox(message: "Failed to delete company."),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF3F3F3),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            Stack(
              children: [
                const ElevateHeader(
                  title: "Manage",
                  subTitle: "Companies",
                  titleSize: 40,
                  subtitleSize: 25,
                ),
                Positioned(
                  top: 170,
                  right: 120,
                  child: TexxtButton(
                    text: "Back",
                    width: 120,
                    height: 50,
                    textSize: 12,
                    textWeight: FontWeight.w500,
                    textColor: const Color.fromARGB(255, 255, 255, 255),
                    backgroundColor: const Color.fromARGB(224, 114, 114, 114),
                    borderColor: const Color(0xFF8B8B8B),
                    borderRadius: 80,
                    borderWidth: 1,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: "Delete Companies",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ElevateColor.black,
                    ),

                    const SizedBox(height: 15),

                    CustomSearchBar(
                      hintText: "Search by name",
                      backgroundColor: ElevateColor.white,
                      width: 380,
                      height: 60,
                      textSize: 15,
                      iconSize: 30,
                      controller: searchController,
                      onChanged: onSearchChanged,
                    ),

                    const SizedBox(height: 20),

                    if (isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: CircularProgressIndicator(color: Colors.black),
                        ),
                      )
                    else if (visibleCompanies.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: CustomText(
                            text: "No companies found.",
                            fontSize: 15,
                            color: ElevateColor.gray,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    else
                      Column(
                        children: visibleCompanies.map((company) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ExperienceWhiteBlackFull(
                              imageURL: company.logo.isNotEmpty
                                  ? company.logo
                                  : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(company.companyName.isNotEmpty ? company.companyName : "Company")}&background=E0E0E0&color=757575&size=128&bold=true',
                              name: company.companyName,
                              shortDescription: company.industry.isNotEmpty
                                  ? company.industry
                                  : "Company",
                              experience: company.location.isNotEmpty
                                  ? company.location
                                  : "Not specified",
                              firstContainerWidth: 270,
                              experienceBoxWidth: 240,
                              iconData: Icons.delete,
                              onTap: () => deleteCompany(company),
                            ),
                          );
                        }).toList(),
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
