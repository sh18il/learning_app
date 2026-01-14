class HomeResponse {
  final User? user;
  final List<HeroBanner>? heroBanners;
  final ActiveCourse? activeCourse;
  final List<PopularCourseCategory>? popularCourses;
  final LiveSession? liveSession;

  HomeResponse({
    this.user,
    this.heroBanners,
    this.activeCourse,
    this.popularCourses,
    this.liveSession,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      heroBanners: (json['hero_banners'] as List<dynamic>?)
          ?.map((e) => HeroBanner.fromJson(e))
          .toList(),
      activeCourse: json['active_course'] != null
          ? ActiveCourse.fromJson(json['active_course'])
          : null,
      popularCourses: (json['popular_courses'] as List<dynamic>?)
          ?.map((e) => PopularCourseCategory.fromJson(e))
          .toList(),
      liveSession: json['live_session'] != null
          ? LiveSession.fromJson(json['live_session'])
          : null,
    );
  }
}

class User {
  final String? name;
  final String? greeting;
  final Streak? streak;

  User({this.name, this.greeting, this.streak});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name']?.toString(),
      greeting: json['greeting']?.toString(),
      streak: json['streak'] != null ? Streak.fromJson(json['streak']) : null,
    );
  }
}

class Streak {
  final int? days;
  final String? icon;

  Streak({this.days, this.icon});

  factory Streak.fromJson(Map<String, dynamic> json) {
    return Streak(days: json['days'] as int?, icon: json['icon']?.toString());
  }
}

class HeroBanner {
  final int? id;
  final String? title;
  final String? image;
  final bool? isActive;

  HeroBanner({this.id, this.title, this.image, this.isActive});

  factory HeroBanner.fromJson(Map<String, dynamic> json) {
    return HeroBanner(
      id: json['id'] as int?,
      title: json['title']?.toString(),
      image: json['image']?.toString(),
      isActive: json['is_active'] as bool? ?? false,
    );
  }
}

class ActiveCourse {
  final int? id;
  final String? title;
  final int? progress;
  final int? testsCompleted;
  final int? totalTests;

  ActiveCourse({
    this.id,
    this.title,
    this.progress,
    this.testsCompleted,
    this.totalTests,
  });

  factory ActiveCourse.fromJson(Map<String, dynamic> json) {
    return ActiveCourse(
      id: json['id'] as int?,
      title: json['title']?.toString(),
      progress: json['progress'] as int?,
      testsCompleted: json['tests_completed'] as int?,
      totalTests: json['total_tests'] as int?,
    );
  }
}

class PopularCourseCategory {
  final int? id;
  final String? name;
  final List<Course>? courses;

  PopularCourseCategory({this.id, this.name, this.courses});

  factory PopularCourseCategory.fromJson(Map<String, dynamic> json) {
    return PopularCourseCategory(
      id: json['id'] as int?,
      name: json['name']?.toString(),
      courses: (json['courses'] as List<dynamic>?)
          ?.map((e) => Course.fromJson(e))
          .toList(),
    );
  }
}

class Course {
  final int? id;
  final String? title;
  final String? image;
  final String? action;

  Course({this.id, this.title, this.image, this.action});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int?,
      title: json['title']?.toString(),
      image: json['image']?.toString(),
      action: json['action']?.toString(),
    );
  }
}

class LiveSession {
  final int? id;
  final bool? isLive;
  final String? title;
  final Instructor? instructor;
  final SessionDetails? sessionDetails;
  final String? action;

  LiveSession({
    this.id,
    this.isLive,
    this.title,
    this.instructor,
    this.sessionDetails,
    this.action,
  });

  factory LiveSession.fromJson(Map<String, dynamic> json) {
    return LiveSession(
      id: json['id'] as int?,
      isLive: json['is_live'] as bool? ?? false,
      title: json['title']?.toString(),
      instructor: json['instructor'] != null
          ? Instructor.fromJson(json['instructor'])
          : null,
      sessionDetails: json['session_details'] != null
          ? SessionDetails.fromJson(json['session_details'])
          : null,
      action: json['action']?.toString(),
    );
  }
}

class Instructor {
  final String? name;

  Instructor({this.name});

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(name: json['name']?.toString());
  }
}

class SessionDetails {
  final int? sessionNumber;
  final String? date;
  final String? time;

  SessionDetails({this.sessionNumber, this.date, this.time});

  factory SessionDetails.fromJson(Map<String, dynamic> json) {
    return SessionDetails(
      sessionNumber: json['session_number'] as int?,
      date: json['date']?.toString(),
      time: json['time']?.toString(),
    );
  }
}
