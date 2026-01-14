class StreakResponse {
  final int? currentDay;
  final int? totalDays;
  final List<StreakDay>? days;

  StreakResponse({this.currentDay, this.totalDays, this.days});

  factory StreakResponse.fromJson(Map<String, dynamic> json) {
    return StreakResponse(
      currentDay: json['current_day'] as int?,
      totalDays: json['total_days'] as int?,
      days: (json['days'] as List<dynamic>?)
          ?.map((e) => StreakDay.fromJson(e))
          .toList(),
    );
  }
}

class StreakDay {
  final int? id;
  final int? dayNumber;
  final String? label;
  final bool? isCompleted;
  final bool? isCurrent;
  final Topic? topic;

  StreakDay({
    this.id,
    this.dayNumber,
    this.label,
    this.isCompleted,
    this.isCurrent,
    this.topic,
  });

  factory StreakDay.fromJson(Map<String, dynamic> json) {
    return StreakDay(
      id: json['id'] as int?,
      dayNumber: json['day_number'] as int?,
      label: json['label']?.toString(),
      isCompleted: json['is_completed'] as bool? ?? false,
      isCurrent: json['is_current'] as bool? ?? false,
      topic: json['topic'] != null ? Topic.fromJson(json['topic']) : null,
    );
  }
}

class Topic {
  final String? title;
  final List<Module>? modules;

  Topic({this.title, this.modules});

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      title: json['title']?.toString(),
      modules: (json['modules'] as List<dynamic>?)
          ?.map((e) => Module.fromJson(e))
          .toList(),
    );
  }
}

class Module {
  final String? name;
  final String? description;

  Module({this.name, this.description});

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      name: json['name']?.toString(),
      description: json['description']?.toString(),
    );
  }
}
