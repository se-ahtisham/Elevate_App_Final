import 'package:elevate_app/Custom_Widgets/Buttons/circle_icon_button.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/message.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/user_description_short.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:flutter/material.dart';

class CompanyMessageScreen extends StatefulWidget {
  const CompanyMessageScreen({super.key});

  @override
  State<CompanyMessageScreen> createState() => _CompanyMessageScreenState();
}

class _CompanyMessageScreenState extends State<CompanyMessageScreen> {
  final TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
              child: Row(
                children: [
                  CircleIconButton(
                    iconData: Icons.arrow_back,
                    circleSize: 45,
                    iconSize: 20,
                    circleColor: const Color.fromARGB(255, 51, 51, 51),
                    iconColor: const Color.fromARGB(255, 238, 238, 238),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 226, 226, 226),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: UserDescriptionShort(
                          imageURL:
                              "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                          name: "AHTISHAM ARSHAD",
                          shortDescription: "Software Engineer",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: const [
                  Message(
                    text: "Let's get lunch. How about pizza?",
                    isMe: true,
                  ),
                  Message(
                    text: "Let's do it! I'm in a meeting until noon.",
                    isMe: false,
                  ),
                  Message(
                    text: "That's perfect. There's a new place on Main St.",
                    isMe: true,
                  ),
                  Message(text: "I kind of like pineapple pizza.", isMe: false),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, bottom: 50.0),
              child: Row(
                children: [
                  Container(
                    width: 350,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 233, 233, 233),
                      border: Border.all(color: const Color.fromARGB(255, 75, 75, 75),),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CustomTextField(
                        controller: messageController,
                        hintText: "Type message...",
                        cursorColor: Colors.black,
                        underlineColor: Colors.transparent,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleIconButton(
                    iconData: Icons.send,
                    circleSize: 45,
                    circleColor: Colors.black,
                    iconColor: Colors.white,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
