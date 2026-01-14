import 'package:get/get.dart';
import '../../views/onboarding/onboarding_page.dart';
import '../../views/home/home_page.dart';
import '../../views/videos/videos_page.dart';
import '../../views/streak/streak_page.dart';
import '../routes/app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.onboarding, page: () => OnboardingPage()),
    GetPage(name: AppRoutes.home, page: () => HomePage()),
    GetPage(name: AppRoutes.videos, page: () => VideosPage()),
    GetPage(name: AppRoutes.streak, page: () => StreakPage()),
  ];
}
