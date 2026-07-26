import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Message_Box/messageBox.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_model.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminUpdateCompanyProfile extends StatefulWidget {
  const AdminUpdateCompanyProfile({super.key});

  @override
  State<AdminUpdateCompanyProfile> createState() =>
      _AdminUpdateCompanyProfileState();
}

class _AdminUpdateCompanyProfileState extends State<AdminUpdateCompanyProfile> {
  final FirebaseService firebaseService = FirebaseService();

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final industryController = TextEditingController();
  final websiteController = TextEditingController();
  final logoController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final companySizeController = TextEditingController();

  final List<TextEditingController> strengthList = [];
  final List<TextEditingController> weaknessList = [];
  final List<TextEditingController> achievementList = [];

  CompanyModel? foundCompany;
  bool isSearching = false;
  bool isUpdating = false;

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    industryController.dispose();
    websiteController.dispose();
    logoController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    companySizeController.dispose();
    for (final c in strengthList) c.dispose();
    for (final c in weaknessList) c.dispose();
    for (final c in achievementList) c.dispose();
    super.dispose();
  }

  Future<void> searchCompany() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => const Messagebox(message: "Please enter an email."),
      );
      return;
    }

    setState(() => isSearching = true);

    try {
      final company = await firebaseService.getCompanyByEmail(email);

      setState(() => isSearching = false);
      if (!mounted) return;

      if (company == null) {
        showDialog(
          context: context,
          builder: (_) => const Messagebox(message: "Company not found."),
        );
        return;
      }

      foundCompany = company;
      nameController.text = company.companyName;
      industryController.text = company.industry;
      websiteController.text = company.website;
      logoController.text = company.logo;
      descriptionController.text = company.description;
      locationController.text = company.location;
      companySizeController.text = company.companySize.toString();

      strengthList.clear();
      for (final s in company.companyStrengthList) {
        strengthList.add(TextEditingController(text: s));
      }

      weaknessList.clear();
      for (final w in company.companyWeaknessList) {
        weaknessList.add(TextEditingController(text: w));
      }

      achievementList.clear();
      for (final a in company.achievementList) {
        achievementList.add(TextEditingController(text: a));
      }

      setState(() {});
    } catch (e) {
      if (!mounted) return;
      setState(() => isSearching = false);
      showDialog(
        context: context,
        builder: (_) => Messagebox(message: e.toString()),
      );
    }
  }

  Future<void> updateCompany() async {
    if (foundCompany == null) return;

    setState(() => isUpdating = true);

    try {
      await firebaseService.updateCompany(foundCompany!.companyID, {
        'companyName': nameController.text.trim(),
        'industry': industryController.text.trim(),
        'website': websiteController.text.trim(),
        'logo': logoController.text.trim(),
        'description': descriptionController.text.trim(),
        'location': locationController.text.trim(),
        'companySize': int.tryParse(companySizeController.text.trim()) ?? 0,
        'companyStrengthList': strengthList
            .map((c) => c.text.trim())
            .where((t) => t.isNotEmpty)
            .toList(),
        'companyWeaknessList': weaknessList
            .map((c) => c.text.trim())
            .where((t) => t.isNotEmpty)
            .toList(),
        'achievementList': achievementList
            .map((c) => c.text.trim())
            .where((t) => t.isNotEmpty)
            .toList(),
      });

      if (!mounted) return;
      setState(() => isUpdating = false);

      showDialog(
        context: context,
        builder: (_) => Messagebox(
          message: "Company updated successfully.",
          onOkTap: () => Navigator.pop(context),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => isUpdating = false);
      showDialog(
        context: context,
        builder: (_) => Messagebox(message: e.toString()),
      );
    }
  }

  // Small reusable section for a list of plain text items (strengths,
  // weaknesses, achievements) with add/remove — same idea as education.
  Widget _listSection({
    required String label,
    required List<TextEditingController> controllers,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomText(
              text: label,
              fontSize: 15,
              color: const Color.fromARGB(255, 44, 44, 44),
              fontWeight: FontWeight.w500,
            ),
            const Spacer(),
            GestureDetector(
              onTap: () =>
                  setState(() => controllers.add(TextEditingController())),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 59, 59, 59),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add, size: 18, color: Colors.white),
              ),
            ),
          ],
        ),
        for (int i = 0; i < controllers.length; i++)
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color.fromARGB(255, 75, 75, 75)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    hintText: hint,
                    controller: controllers[i],
                    cursorColor: ElevateColor.black,
                    underlineColor: Colors.transparent,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => setState(() => controllers.removeAt(i)),
                  child: const Icon(Icons.delete, size: 20, color: Colors.red),
                ),
              ],
            ),
          ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _boxedField({
    required TextEditingController controller,
    required String hintText,
    double height = 40,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 75, 75, 75)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: CustomTextField(
          hintText: hintText,
          controller: controller,
          cursorColor: ElevateColor.black,
          underlineColor: Colors.transparent,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                const ElevateHeader(
                  title: "Company Info",
                  subTitle: "Let's Discover Company",
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Search by Email",
                      fontSize: 15,
                      color: const Color.fromARGB(255, 44, 44, 44),
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 10),
                    _boxedField(
                      controller: emailController,
                      hintText: "Enter company's email",
                    ),
                    const SizedBox(height: 16),
                    isSearching
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          )
                        : TextButtonGradient(
                            text: "Search",
                            height: 50,
                            borderRadius: 50,
                            textSize: 14,
                            textWeight: FontWeight.w500,
                            onTap: searchCompany,
                          ),

                    if (foundCompany != null) ...[
                      const SizedBox(height: 30),

                      CustomText(
                        text: "Company Name",
                        fontSize: 15,
                        color: const Color.fromARGB(255, 44, 44, 44),
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(height: 10),
                      _boxedField(
                        controller: nameController,
                        hintText: "Company name",
                      ),
                      const SizedBox(height: 30),

                      CustomText(
                        text: "Industry",
                        fontSize: 15,
                        color: const Color.fromARGB(255, 44, 44, 44),
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(height: 10),
                      _boxedField(
                        controller: industryController,
                        hintText: "e.g. FinTech",
                      ),
                      const SizedBox(height: 30),

                      CustomText(
                        text: "Website",
                        fontSize: 15,
                        color: const Color.fromARGB(255, 44, 44, 44),
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(height: 10),
                      _boxedField(
                        controller: websiteController,
                        hintText: "www.example.com",
                      ),
                      const SizedBox(height: 30),

                      CustomText(
                        text: "Logo URL",
                        fontSize: 15,
                        color: const Color.fromARGB(255, 44, 44, 44),
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(height: 10),
                      _boxedField(
                        controller: logoController,
                        hintText: "https://...",
                      ),
                      const SizedBox(height: 30),

                      CustomText(
                        text: "Description",
                        fontSize: 15,
                        color: const Color.fromARGB(255, 44, 44, 44),
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(height: 10),
                      _boxedField(
                        controller: descriptionController,
                        hintText: "About the company",
                        height: 150,
                      ),
                      const SizedBox(height: 30),

                      CustomText(
                        text: "Location",
                        fontSize: 15,
                        color: const Color.fromARGB(255, 44, 44, 44),
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(height: 10),
                      _boxedField(
                        controller: locationController,
                        hintText: "e.g. Lahore, Pakistan",
                      ),
                      const SizedBox(height: 30),

                      CustomText(
                        text: "Company Size",
                        fontSize: 15,
                        color: const Color.fromARGB(255, 44, 44, 44),
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(height: 10),
                      _boxedField(
                        controller: companySizeController,
                        hintText: "Number of employees",
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 30),

                      _listSection(
                        label: "Company Strengths",
                        controllers: strengthList,
                        hint: "e.g. Innovation",
                      ),
                      _listSection(
                        label: "Company Weaknesses",
                        controllers: weaknessList,
                        hint: "e.g. High Workload",
                      ),
                      _listSection(
                        label: "Achievements",
                        controllers: achievementList,
                        hint: "e.g. Best FinTech Startup 2024",
                      ),

                      const SizedBox(height: 20),

                      isUpdating
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            )
                          : TextButtonGradient(
                              text: "Update",
                              height: 50,
                              borderRadius: 50,
                              textSize: 14,
                              textWeight: FontWeight.w400,
                              onTap: updateCompany,
                            ),
                      const SizedBox(height: 20),
                      TexxtButton(
                        text: "Cancel",
                        height: 50,
                        textSize: 14,
                        textWeight: FontWeight.w400,
                        textColor: Colors.black,
                        backgroundColor: Colors.transparent,
                        borderRadius: 50,
                        borderColor: Colors.black,
                        onTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: 30),
                    ],
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
