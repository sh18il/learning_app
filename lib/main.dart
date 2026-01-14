import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/app_pages.dart';
import 'controllers/onboarding_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if onboarding is completed
    final onboardingController = Get.put(OnboardingController());
    final isOnboardingCompleted = onboardingController.isOnboardingCompleted();

    return GetMaterialApp(
      title: 'Learning App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: isOnboardingCompleted
          ? AppRoutes.home
          : AppRoutes.onboarding,
      getPages: AppPages.pages,
    );
  }
}
