import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../core/routes/app_routes.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return Center(child: Text(controller.errorMessage.value));
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  _buildHeroBanner(),
                  const SizedBox(height: 24),
                  _buildActiveCourse(),
                  const SizedBox(height: 24),
                  _buildCategoryPills(),
                  const SizedBox(height: 20),
                  _buildPopularCourses(),
                  const SizedBox(height: 24),
                  _buildLiveClass(),
                  const SizedBox(height: 24),

                  _buildContact(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ---------------- APP BAR ----------------

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: ClipPath(
        clipper: WaveClipper(),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      controller.homeData.value?.user?.greeting ??
                          'Good Morning',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _streakPill(),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.notifications_none,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _streakPill() {
    final days = controller.homeData.value?.user?.streak?.days ?? 0;
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.streak),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(
              'Day $days',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            const Text('🔥'),
          ],
        ),
      ),
    );
  }

  // ---------------- HERO ----------------

  Widget _buildHeroBanner() {
    final banners = controller.homeData.value?.heroBanners ?? [];
    if (banners.isEmpty) return const SizedBox();

    return Column(
      children: [
        Transform.translate(
          offset: const Offset(0, -28),
          child: SizedBox(
            height: 160,
            child: PageView.builder(
              controller: controller.pageController,
              itemCount: banners.length,
              onPageChanged: (index) =>
                  controller.currentBannerIndex.value = index,
              itemBuilder: (context, index) {
                return _buildBannerItem(banners[index]);
              },
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(
            0,
            -18,
          ), // Adjust for the negative offset of the banner
          child: SmoothPageIndicator(
            controller: controller.pageController,
            count: banners.length,
            effect: const ExpandingDotsEffect(
              dotHeight: 8,
              dotWidth: 8,
              activeDotColor: AppColors.primary,
              dotColor: AppColors.greyLight,
              expansionFactor: 3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerItem(banner) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8), // Gap between cards
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.12),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Image.network(
            banner.image ?? '',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey.shade200,
              child: const Icon(Icons.image_not_supported, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- ACTIVE COURSE ----------------

  Widget _buildActiveCourse() {
    final course = controller.homeData.value?.activeCourse;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Active Courses',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        value: (course?.progress ?? 0) / 100,
                        strokeWidth: 6,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation(Colors.orange),
                      ),
                    ),
                    Text(
                      '${course?.progress ?? 0}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course?.title ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${course?.testsCompleted ?? 0}/${course?.totalTests ?? 0} Tests',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _pillButton(
                            'Continue >>>',
                            Colors.white,
                            AppColors.primary,
                            onTap: () => Get.toNamed(AppRoutes.videos),
                          ),
                          const SizedBox(width: 10),
                          _pillButton(
                            'Shift Course',
                            Colors.transparent,
                            Colors.white,
                            border: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- CATEGORY PILLS ----------------

  Widget _buildCategoryPills() {
    final categories = controller.homeData.value?.popularCourses ?? [];
    if (categories.isEmpty) return const SizedBox();

    final categoryNames = ['All', ...categories.map((c) => c.name ?? '')];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categoryNames.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isSelected = index == 0;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
              border: isSelected
                  ? null
                  : Border.all(color: Colors.grey.shade200),
            ),
            child: Center(
              child: Text(
                categoryNames[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _pillButton(
    String text,
    Color bg,
    Color fg, {
    bool border = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: border ? Border.all(color: Colors.white) : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: fg,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ---------------- POPULAR COURSES ----------------

  Widget _buildPopularCourses() {
    final categories = controller.homeData.value?.popularCourses ?? [];
    if (categories.isEmpty || categories.first.courses == null) {
      return const SizedBox();
    }

    final courses = categories.first.courses!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Popular Courses',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('View all', style: TextStyle(color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: courses.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: .72,
            ),
            itemBuilder: (context, index) {
              return _courseCard(courses[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _courseCard(course) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            course.image ?? '',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: AppColors.greyLight),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    course.action ?? 'Explore',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- LIVE ----------------

  Widget _buildLiveClass() {
    final session = controller.homeData.value?.liveSession;
    if (session == null || session.isLive != true) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardYellow,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.green,
              child: Text(
                'Live',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${session.title ?? 'Live Session'}\nSession ${session.sessionDetails?.sessionNumber ?? 1} • ${session.sessionDetails?.time ?? ''}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: const StadiumBorder(),
              ),
              child: Text(session.action ?? 'Join Now'),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- CONTACT ----------------

  Widget _buildContact() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.chat),
                label: const Text('Chat with us'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.phone),
                label: const Text('Call us'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- BOTTOM NAV ----------------

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 0,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Courses'),
        BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Tools'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}

// ---------------- CLIPPER ----------------

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 20,
      size.width,
      size.height - 30,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
