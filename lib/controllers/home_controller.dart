import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/home_model.dart';
import '../data/services/api_service.dart';

class HomeController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = true.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  Rx<HomeResponse?> homeData = Rx<HomeResponse?>(null);
  final PageController pageController = PageController(viewportFraction: 0.9);
  var currentBannerIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final data = await _apiService.fetchHomeData();
      homeData.value = data;

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  void retry() {
    fetchHomeData();
  }
}
