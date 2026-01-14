import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';
import '../models/home_model.dart';
import '../models/video_model.dart';
import '../models/streak_model.dart';

class ApiService {
  // Fetch home page data
  Future<HomeResponse> fetchHomeData() async {
    try {
      final url = Uri.parse(
        '${AppConstants.baseUrl}${AppConstants.homeEndpoint}',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return HomeResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load home data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching home data: $e');
    }
  }

  // Fetch video details
  Future<VideoDetailsResponse> fetchVideoDetails() async {
    try {
      final url = Uri.parse(
        '${AppConstants.baseUrl}${AppConstants.videoDetailsEndpoint}',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return VideoDetailsResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load video details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching video details: $e');
    }
  }

  // Fetch streak data
  Future<StreakResponse> fetchStreakData() async {
    try {
      final url = Uri.parse(
        '${AppConstants.baseUrl}${AppConstants.streakEndpoint}',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return StreakResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load streak data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching streak data: $e');
    }
  }
}
