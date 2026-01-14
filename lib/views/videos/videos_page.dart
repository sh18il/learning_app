import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learningapp/data/models/video_model.dart';
import 'package:video_player/video_player.dart';
import '../../controllers/video_controller.dart';
import '../../core/theme/app_theme.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({super.key});

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  final VideoController controller = Get.put(VideoController());

  VideoPlayerController? _player;
  int _currentIndex = 0;

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  void _playVideo(VideoItem video, int index) async {
    if (video.isLocked || video.videoUrl == null) return;

    _player?.dispose();

    _player = VideoPlayerController.networkUrl(Uri.parse(video.videoUrl!));

    await _player!.initialize();
    await _player!.play();

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Video',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.videoData.value?.data;
        final videos = data?.videos ?? [];

        if (data == null || videos.isEmpty) {
          return const Center(child: Text('No videos available'));
        }

        final currentVideo = videos[_currentIndex];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _videoPlayer(currentVideo),
            _videoInfo(currentVideo),
            _journeyTitle(data.title ?? ''),
            Expanded(child: _videoTimeline(videos)),
          ],
        );
      }),
    );
  }

  // ---------------- VIDEO PLAYER ----------------

  Widget _videoPlayer(VideoItem video) {
    if (_player == null || !_player!.value.isInitialized) {
      return _videoThumbnail(video);
    }

    return Stack(
      children: [
        AspectRatio(
          aspectRatio: _player!.value.aspectRatio,
          child: VideoPlayer(_player!),
        ),

        /// play / pause
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _player!.value.isPlaying ? _player!.pause() : _player!.play();
              });
            },
            child: Center(
              child: Icon(
                _player!.value.isPlaying
                    ? Icons.pause_circle
                    : Icons.play_circle,
                size: 64,
                color: Colors.white.withOpacity(.8),
              ),
            ),
          ),
        ),

        /// progress
        Positioned(
          bottom: 8,
          left: 12,
          right: 12,
          child: VideoProgressIndicator(
            _player!,
            allowScrubbing: true,
            colors: VideoProgressColors(
              playedColor: Colors.white,
              bufferedColor: Colors.white38,
              backgroundColor: Colors.white24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _videoThumbnail(VideoItem video) {
    return GestureDetector(
      onTap: () => _playVideo(video, _currentIndex),
      child: Stack(
        children: [
          Container(
            height: 220,
            color: Colors.black,
            alignment: Alignment.center,
            child: const Icon(
              Icons.play_circle_outline,
              size: 80,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- VIDEO INFO ----------------

  Widget _videoInfo(VideoItem video) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  video.description ?? '',
                  style: TextStyle(color: AppColors.grey),
                ),
              ],
            ),
          ),
          Obx(() {
            if (controller.isDownloading.value) {
              return SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  value: controller.downloadProgress.value,
                  strokeWidth: 2,
                ),
              );
            }
            return IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {
                if (video.videoUrl != null) {
                  controller.downloadVideo(
                    video.videoUrl!,
                    video.title ??
                        'video_${DateTime.now().millisecondsSinceEpoch}',
                  );
                } else {
                  Get.snackbar('Error', 'Video URL not found');
                }
              },
            );
          }),
        ],
      ),
    );
  }

  // ---------------- JOURNEY TITLE ----------------

  Widget _journeyTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ---------------- VIDEO LIST ----------------

  Widget _videoTimeline(List<VideoItem> videos) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];

        return GestureDetector(
          onTap: () => _playVideo(video, index),
          child: _timelineItem(video, index, index == videos.length - 1),
        );
      },
    );
  }

  Widget _timelineItem(VideoItem video, int index, bool isLast) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: video.isCompleted
                  ? AppColors.success
                  : video.isLocked
                  ? Colors.white
                  : AppColors.primary,
              child: Icon(
                video.isCompleted
                    ? Icons.check
                    : video.isLocked
                    ? Icons.lock
                    : Icons.play_arrow,
                size: 14,
                color: video.isLocked ? AppColors.grey : Colors.white,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: AppColors.success.withOpacity(.4),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 12),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  video.description ?? '',
                  style: TextStyle(color: AppColors.grey, fontSize: 12),
                ),
                if (video.isInProgress)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: LinearProgressIndicator(
                      value: (video.progressPercentage ?? 0) / 100,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
