import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../data/models/video_model.dart';
import '../data/services/api_service.dart';

class VideoController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = true.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  Rx<VideoDetailsResponse?> videoData = Rx<VideoDetailsResponse?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchVideoDetails();
  }

  Future<void> fetchVideoDetails() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final data = await _apiService.fetchVideoDetails();
      videoData.value = data;

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  void retry() {
    fetchVideoDetails();
  }

  var isDownloading = false.obs;
  var downloadProgress = 0.0.obs;

  Future<void> downloadVideo(String url, String fileName) async {
    // 1. Check Permissions
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      // Handle Android 13+ separate media permissions or fallback
      var videoStatus = await Permission.videos.request();
      if (!videoStatus.isGranted) {
        // Just try to proceed if denied, sometimes permissions aren't needed for app directories
        // or show message
      }
    }

    try {
      isDownloading.value = true;
      downloadProgress.value = 0.0;

      // 2. Get Directory
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        // Fallback for safety
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        Get.snackbar('Error', 'Could not find storage directory');
        isDownloading.value = false;
        return;
      }

      final savePath = '${directory.path}/$fileName.mp4';

      // 3. Download
      await Dio().download(
        url,
        savePath,
        onReceiveProgress: (count, total) {
          if (total != -1) {
            downloadProgress.value = count / total;
          }
        },
      );

      Get.snackbar('Success', 'Video downloaded to $savePath');
    } catch (e) {
      Get.snackbar('Error', 'Download failed: $e');
    } finally {
      isDownloading.value = false;
      downloadProgress.value = 0.0;
    }
  }
}
