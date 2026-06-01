import 'package:elevate_app/Custom_Widgets/Buttons/circle_icon_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';


class CompanyPortfolioCheckDes extends StatelessWidget {
  static const List<String> previewImages = [
    "lib/Resources/Images/mock.png",
    "lib/Resources/Images/mock2.png",
    "lib/Resources/Images/mock.png",
    "lib/Resources/Images/mock2.png",
  ];
  const CompanyPortfolioCheckDes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      body: Stack(
        children: [
          Column(
            children: [
              ElevateHeader(),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        const CustomText(
                          text: "My Creation",
                          fontSize: 16,
                          textAlign: TextAlign.left,
                          fontWeight: FontWeight.w700,
                          color: ElevateColor.lightgray,
                          lineHeight: 1.2,
                        ),
                        const SizedBox(height: 12),

                        SizedBox(
                          height: 92,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: previewImages.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 14),
                            itemBuilder: (context, i) {
                              return _PreviewCard(
                                imagePath: previewImages[i],
                                heroTag: "preview_$i", // unique hero tag
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 20),
                        const CustomText(
                          text: "Description",
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: ElevateColor.lightgray,
                          lineHeight: 1.2,
                        ),
                        const SizedBox(height: 10),
                        const CustomText(
                          text:
                              "We are seeking a talented UI/UX Designer to join "
                              "our team and craft engaging, user-friendly digital "
                              "experiences. You will be responsible for designing",
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                          color: ElevateColor.whitegray,
                          lineHeight: 1.45,
                        ),

                        const SizedBox(height: 18),

                        const CustomText(
                          text: "Files",
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: ElevateColor.lightgray,
                          lineHeight: 1.2,
                        ),
                        const SizedBox(height: 12),

                        _FilePill(fileName: "index.html", onDownload: () {}),
                        const SizedBox(height: 12),
                        _FilePill(fileName: "java.zip", onDownload: () {}),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // floating header
          Padding(
            padding: EdgeInsets.only(left: 18, right: 18, top: 150),
            child: Container(
              width: double.infinity,
              height: 140,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
              decoration: BoxDecoration(
                color: ElevateColor.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 18,
                    color: Colors.black.withValues(alpha: 0.12),
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  CustomText(
                    text: "E-Commerce\nMobile Application",
                    textAlign: TextAlign.center,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: ElevateColor.lightgray,
                    lineHeight: 1.15,
                  ),
                  SizedBox(height: 10),
                  CustomText(
                    text: "Lead Developer",
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: ElevateColor.whitegray,
                    lineHeight: 1.2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//  Preview Card (TAP -> FULL SCREEN)

class _PreviewCard extends StatelessWidget {
  final String imagePath;
  final String heroTag;

  const _PreviewCard({required this.imagePath, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                _FullScreenImage(imagePath: imagePath, heroTag: heroTag),
          ),
        );
      },
      child: Container(
        width: 156,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ElevateColor.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 14,
              color: Colors.black.withValues(alpha: 0.08),
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Hero(
          tag: heroTag,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFFF2F2F2),
              alignment: Alignment.center,
              child: const Icon(
                Icons.image_outlined,
                size: 28,
                color: Color(0xFF9B9B9B),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FullScreenImage extends StatelessWidget {
  final String imagePath;
  final String heroTag;

  const _FullScreenImage({required this.imagePath, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElevateColor.black,
      body: Stack(
        children: [
          Center(
            child: Hero(
              tag: heroTag,
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 4.0,
                child: Image.asset(imagePath),
              ),
            ),
          ),

          Positioned(
            top: 50,
            left: 20,
            child: CircleIconButton(
              iconData: Icons.arrow_back,
              circleSize: 40,
              iconSize: 20,
              circleColor: ElevateColor.white.withValues(alpha: 0.20),
              iconColor: ElevateColor.white,
              rippleColor: ElevateColor.white.withValues(alpha: 0.30),
              onTap: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

//  Files Pill container with download button

class _FilePill extends StatelessWidget {
  final String fileName;
  final VoidCallback onDownload;

  const _FilePill({required this.fileName, required this.onDownload});

  @override
  Widget build(BuildContext context) {
    const border = Color(0xFFE0E0E0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: ElevateColor.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        children: [
          const SizedBox(width: 4),
          CustomText(
            text: fileName,
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: ElevateColor.lightgray,
            lineHeight: 1.2,
          ),
          const Spacer(),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onDownload,
            child: const Padding(
              padding: EdgeInsets.all(6.0),
              child: Icon(
                Icons.download_rounded,
                size: 20,
                color: ElevateColor.lightgray,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
