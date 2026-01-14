class VideoDetailsResponse {
  final int? status;
  final String? message;
  final VideoData? data;

  VideoDetailsResponse({this.status, this.message, this.data});

  factory VideoDetailsResponse.fromJson(Map<String, dynamic> json) {
    return VideoDetailsResponse(
      status: json['status'] as int?,
      message: json['message']?.toString(),
      data: json['data'] != null ? VideoData.fromJson(json['data']) : null,
    );
  }
}

class VideoData {
  final String? title;
  final List<VideoItem>? videos;

  VideoData({this.title, this.videos});

  factory VideoData.fromJson(Map<String, dynamic> json) {
    return VideoData(
      title: json['title']?.toString(),
      videos: (json['videos'] as List<dynamic>?)
          ?.map((e) => VideoItem.fromJson(e))
          .toList(),
    );
  }
}

class VideoItem {
  final int? id;
  final String? title;
  final String? description;
  final String? status;
  final String? videoUrl;
  final int? totalDuration;
  final int? watchedDuration;
  final int? progressPercentage;
  final bool? hasPlayButton;

  VideoItem({
    this.id,
    this.title,
    this.description,
    this.status,
    this.videoUrl,
    this.totalDuration,
    this.watchedDuration,
    this.progressPercentage,
    this.hasPlayButton,
  });

  factory VideoItem.fromJson(Map<String, dynamic> json) {
    return VideoItem(
      id: json['id'] as int?,
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      status: json['status']?.toString(),
      videoUrl: json['video_url']?.toString(),
      totalDuration: json['total_duration'] as int?,
      watchedDuration: json['watched_duration'] as int?,
      progressPercentage: json['progress_percentage'] as int?,
      hasPlayButton: json['has_play_button'] as bool? ?? false,
    );
  }

  bool get isCompleted => status == 'completed';
  bool get isLocked => status == 'locked';
  bool get isInProgress => status == 'in_progress';
}
