import 'package:cloud_firestore/cloud_firestore.dart';

class Routine {
  String name;
  List<RoutineItem> items;
  Timestamp? startAt = Timestamp.now();
  int cycle;
  CycleUnit unit;
  Timestamp nextStartAt;
  String specId;
  bool shouldNotify = false;
  bool isAchived = false;
  Timestamp? archivedAt;

  Routine(
      {required this.name,
      required this.items,
      required this.cycle,
      required this.unit,
      required this.specId,
      this.startAt})
      : nextStartAt = calculateDuration(unit, cycle);

  Routine.fromMap(Map<String, dynamic> map)
      : assert(map['name'] != null, "'name' cannot be null."),
        assert(map['specId'] != null, "'specId' cannot be null."),
        assert(
            map['items'] != null && map['items'] is List<Map<String, dynamic>>,
            "'items must be a list of RoutineItem."),
        assert(map['cycle'] != null, "'cycle' cannot be null."),
        assert(map['cycleUnit'] != null, "'cycleUnit' cannot be null."),
        name = map['name'],
        items =
            List.from(map['items'].map((item) => RoutineItem.fromMap(item))),
        cycle = map['cycle'],
        unit = map['unit'],
        nextStartAt = calculateDuration(map['unit'], map['cycle']),
        specId = map['specId'];

  Map<String, dynamic> get asMap {
    return <String, dynamic>{
      'name': name,
      'items': items,
      'cycle': cycle,
      'cycleUnit': unit,
      'startAt': startAt,
      'nextStartAt': nextStartAt,
    };
  }

  static Future<void> check() async {}

  static Future<void> uncheck() async {}

  static Future<void> achive() async {}

  static Timestamp calculateDuration(CycleUnit unit, int cycle) {
    DateTime now = DateTime.now().toUtc();
    int currentMonth = now.month;
    int currentYear = now.year;
    int currentDay = now.day;
    int currentHour = now.hour;
    int currentMinute = now.minute;
    int currentSecond = now.second;

    switch (unit) {
      case CycleUnit.minute:
        assert(cycle > 0 && cycle < 60,
            "'cycle' must be integer between 1 and 59");
        return Timestamp.fromDate(DateTime(currentYear, currentMonth,
            currentDay, currentHour, currentMinute + cycle, currentSecond));
      case CycleUnit.hour:
        assert(cycle > 0 && cycle < 24,
            "'cycle' must be integer between 1 and 23");
        return Timestamp.fromDate(DateTime(currentYear, currentMonth,
            currentDay, currentHour + cycle, currentMinute, currentSecond));
      case CycleUnit.day:
        assert(cycle > 0 && cycle <= 28,
            "'cycle' must be integer between 1 and 28");
        return Timestamp.fromDate(DateTime(currentYear, currentMonth,
            currentDay + cycle, currentHour, currentMinute, currentSecond));
      case CycleUnit.month:
        assert(cycle > 0 && cycle <= 11,
            "'cycle' must be integer between 1 and 11");
        return Timestamp.fromDate(DateTime(currentYear, currentMonth + cycle,
            currentDay, currentHour, currentMinute, currentSecond));
      case CycleUnit.year:
        assert(cycle > 0, "'cycle' must be integer greater than 0");
        return Timestamp.fromDate(DateTime(currentYear + cycle, currentMonth,
            currentDay, currentHour, currentMinute, currentSecond));
    }
  }
}

class RoutineItem {
  final String content;
  bool isChecked;

  RoutineItem(this.content, [this.isChecked = false]);

  RoutineItem.fromMap(Map<String, dynamic> map)
      : content = map['content'],
        isChecked = map['isChecked'] ?? false;
}

enum CycleUnit {
  minute,
  hour,
  day,
  month,
  year,
}
