import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/admin_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevateHeader(
              title: "Ahtisham Dashboard",
              subTitle: "Check the Statictics",
            ),

            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 40, bottom: 20),
              child: Container(
                height: 50,
                width: 370,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child: CustomText(
                    text: "App Performance Metrics",
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),

            Expanded(
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 40),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AdminCard(
                        topText: "Total",
                        bottomText: "Job Seekers",
                        count: 121,
                      ),
                      SizedBox(height: 20),
                      AdminCard(
                        topText: "Total",
                        bottomText: "Companies",
                        count: 12,
                      ),
                      SizedBox(height: 20),
                      AdminCard(
                        topText: "Total",
                        bottomText: "Skills",
                        count: 12,
                      ),
                      SizedBox(height: 30),
                      AdminCard(
                        topText: "Total",
                        bottomText: "Jobs",
                        count: 120,
                      ),
                      SizedBox(height: 20),
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
