import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../controllers/onboarding_controller.dart';

import '../../core/theme/app_theme.dart';

class OnboardingPage extends StatelessWidget {
  OnboardingPage({Key? key}) : super(key: key);

  final OnboardingController controller = Get.put(OnboardingController());
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: PageView(
        controller: pageController,
        onPageChanged: controller.updatePageIndex,
        children: [
          OnboardingItem(
            image: 'assets/image1.png',
            title: 'Smarter Learning\nStarts Here',
            subtitle:
                'Personalized lessons that adapt to\nyour pace and goals.',
            controller: pageController,
            index: 0,
            onSkip: controller.skipOnboarding,
            alignment: Alignment.centerRight,
            imagePadding: const EdgeInsets.only(left: 30),
          ),
          OnboardingItem(
            image: 'assets/image2.png',
            title: 'Learn. Practice.\nSucceed.',
            subtitle:
                'Structured content, mock tests, and\nprogress tracking in one place.',
            controller: pageController,
            index: 1,
            onSkip: controller.skipOnboarding,
            alignment: Alignment.topCenter,
          ),
        ],
      ),
    );
  }
}

class OnboardingItem extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final PageController controller;
  final int index;
  final VoidCallback onSkip;
  final Alignment alignment;
  final EdgeInsets? imagePadding;

  const OnboardingItem({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.controller,
    required this.index,
    required this.onSkip,
    required this.alignment,
    this.imagePadding,
  });

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          /// Background image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: h * 0.6,
            child: Padding(
              padding: imagePadding ?? EdgeInsets.zero,
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                alignment: alignment,
              ),
            ),
          ),

          /// White curved container
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: BottomCurveClipper(),
              child: Container(
                height: h * 0.5,
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(32, 50, 32, 20),
                child: Column(
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        height: 1.25,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                      ),
                    ),

                    /// Page indicator
                    SmoothPageIndicator(
                      controller: controller,
                      count: 2,
                      effect: ExpandingDotsEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        activeDotColor: Colors.teal,
                        dotColor: Colors.grey.shade300,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Next button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () {
                          if (index == 1) {
                            onSkip();
                          } else {
                            controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          }
                        },
                        child: const Text(
                          'Next',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// Skip
                    TextButton(
                      onPressed: onSkip,
                      child: const Text(
                        'Skip',
                        style: TextStyle(color: Colors.teal, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Floating icon
          Positioned(
            bottom: h * 0.5 - 32,
            left: MediaQuery.of(context).size.width / 2 - 32,
            child: Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset('assets/logooutr.png', fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 40);

    path.quadraticBezierTo(size.width / 2, -40, size.width, 40);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
