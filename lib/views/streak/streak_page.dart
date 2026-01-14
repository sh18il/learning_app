import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learningapp/data/models/streak_model.dart';
import '../../controllers/streak_controller.dart';
import '../../core/theme/app_theme.dart';

class StreakPage extends StatelessWidget {
  StreakPage({super.key});

  final StreakController controller = Get.put(StreakController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return Center(child: Text(controller.errorMessage.value));
        }

        final streak = controller.streakData.value;
        final days = streak?.days ?? [];

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFB2F1F7), Color(0xFFE8FBFD)],
            ),
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final positions = _getPositions(constraints.biggest);

                final currentIndex =
                    days.indexWhere((d) => d.isCurrent == true);

                return Stack(
                  children: [
                    /// dashed curved path
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _StreakPathPainter(),
                      ),
                    ),

                    /// day nodes
                    ...List.generate(days.length, (i) {
                      final d = days[i];
                      final pos = positions[i];

                      return Positioned(
                        left: pos.dx - 35,
                        top: pos.dy - 35,
                        child: _dayNode(
                          day: d.dayNumber ?? (i + 1),
                          completed: d.isCompleted ?? false,
                          isCurrent: d.isCurrent ?? false,
                        ),
                      );
                    }),

                    /// today topic bubble
                    if (currentIndex != -1)
                      _todayBubble(
                        context,
                        positions[currentIndex],
                        days[currentIndex],
                      ),
                  ],
                );
              },
            ),
          ),
        );
      }),
    );
  }

  // ---------------- POSITIONS ----------------

  List<Offset> _getPositions(Size size) {
    final h = size.height;
    final cx = size.width / 2;
    return [
      Offset(cx, h * .85),
      Offset(cx + 90, h * .75),
      Offset(cx - 90, h * .65),
      Offset(cx + 70, h * .55),
      Offset(cx - 70, h * .45),
      Offset(cx + 90, h * .35),
      Offset(cx - 90, h * .25),
      Offset(cx, h * .15),
    ];
  }

  // ---------------- DAY NODE ----------------

  Widget _dayNode({
    required int day,
    required bool completed,
    required bool isCurrent,
  }) {
    final isActive = completed || isCurrent;

    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: isCurrent
                ? AppColors.primary.withOpacity(.5)
                : Colors.black.withOpacity(.15),
            blurRadius: isCurrent ? 14 : 8,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'Day\n$day',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ---------------- TODAY BUBBLE ----------------

  Widget _todayBubble(
    BuildContext context,
    Offset nodePos,
    StreakDay day,
  ) {
    final modules = day.topic?.modules ?? [];
    final primaryModule =
        modules.isNotEmpty ? modules.first.name : '—';

    return Positioned(
      left: nodePos.dx - 110,
      top: nodePos.dy - 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 220,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.25),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day.topic?.title ?? "Today's Topic",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Divider(color: Colors.white30),
                Text(
                  primaryModule ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          CustomPaint(
            size: const Size(20, 10),
            painter: _BubbleArrowPainter(),
          ),
        ],
      ),
    );
  }
}
// ---------------- PATH PAINTER ----------------

class _StreakPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width / 2, size.height * .87);
    path.cubicTo(
      size.width * .85,
      size.height * .73,
      size.width * .15,
      size.height * .63,
      size.width * .50,
      size.height * .50,
    );
    path.cubicTo(
      size.width * .85,
      size.height * .37,
      size.width * .15,
      size.height * .25,
      size.width / 2,
      size.height * .13,
    );

    _drawDashedPath(canvas, path, paint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const dash = 10.0;
    const gap = 8.0;

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + dash), paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------- BUBBLE ARROW ----------------

class _BubbleArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.primary;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height) // Point down
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
