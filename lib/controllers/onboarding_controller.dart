import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';

class OnboardingController extends GetxController {
  final storage = GetStorage();
  var currentPage = 0.obs;

  void updatePageIndex(int index) {
    currentPage.value = index;
  }

  void skipOnboarding() {
    storage.write(AppConstants.onboardingCompletedKey, true);
    Get.offAllNamed(AppRoutes.home);
  }

  void nextPage() {
    if (currentPage.value == 0) {
      currentPage.value = 1;
    } else {
      skipOnboarding();
    }
  }

  bool isOnboardingCompleted() {
    return storage.read(AppConstants.onboardingCompletedKey) ?? false;
  }
}
