import 'package:get/get.dart';
import '../data/models/streak_model.dart';
import '../data/services/api_service.dart';

class StreakController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = true.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  Rx<StreakResponse?> streakData = Rx<StreakResponse?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchStreakData();
  }

  Future<void> fetchStreakData() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final data = await _apiService.fetchStreakData();
      streakData.value = data;

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  void retry() {
    fetchStreakData();
  }
}
