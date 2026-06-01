import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:elevate_app/Custom_Widgets/Text_background_box/custom_text_box.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Profile_Screen/admin_forget_screen.dart';
import 'package:elevate_app/Pages/Login_Screens/user_select.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  TextEditingController aboutController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  void dispose() {
    aboutController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            ElevateHeader(
              title: "Your Info",
              subTitle: "Let’s Discover Yourself",
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(
                              'lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      CustomTextBox(
                        text: "Muhammd Ahtisham",
                        backgroundColor: const Color.fromARGB(
                          255,
                          230,
                          230,
                          230,
                        ),
                        textAlign: TextAlign.center,
                        width: 280,
                        height: 50,
                        textColor: ElevateColor.lightgray,
                        borderRadius: 50,
                      ),
                      SizedBox(height: 30),
                      CustomTextField(
                        hintText: "About",
                        hintWeight: FontWeight.bold,
                        controller: aboutController,
                        cursorColor: ElevateColor.black,
                        underlineColor: ElevateColor.black,
                      ),
                      SizedBox(height: 30),
                      CustomTextField(
                        hintText: "Location",
                        hintWeight: FontWeight.bold,
                        controller: locationController,
                        cursorColor: ElevateColor.black,
                        underlineColor: ElevateColor.black,
                      ),
                      SizedBox(height: 30),
                      TexxtButton(
                        text: "Forget Password",
                        height: 50,
                        textSize: 14,
                        textColor: ElevateColor.whitegray,
                        textWeight: FontWeight.w400,
                        borderRadius: 50,
                        backgroundColor: Colors.transparent,
                        borderColor: ElevateColor.white,
                        borderWidth: 0,
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminForgetScreen(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 25),
                      TextButtonGradient(
                        text: "Log out",
                        height: 50,
                        textSize: 14,
                        textWeight: FontWeight.w400,
                        borderRadius: 50,
                        onTap: () {
                          /* Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ,
                            ),
                          );*/
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
