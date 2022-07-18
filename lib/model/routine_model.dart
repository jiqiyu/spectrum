import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class Routine {
  String name;
  List<String> checkedItems = [];
  List<String> uncheckedItems = [];
  Timestamp startAt = Timestamp.now();
  int cycle;
  CycleUnit unit;
  Timestamp nextStartAt;
  String specName;
  bool shouldNotify = false;
  bool isArchived = false;
  Timestamp? archivedAt;

  Routine(
      {required this.name,
      required this.cycle,
      required this.unit,
      required this.specName,
      required this.startAt})
      : nextStartAt = calculateDuration(unit.name, cycle, startAt);

  Routine.fromMap(Map<String, dynamic> map)
      : assert(map['name'] != null, "'name' cannot be null."),
        assert(map['specName'] != null, "'specName' cannot be null."),
        assert(map['cycle'] != null && map['cycle'] is int,
            "'cycle' must be an integer and cannot be null."),
        assert(map['unit'] != null && map['unit'] is CycleUnit,
            "'unit' must be of CycleUnit and cannot be null."),
        name = map['name'],
        checkedItems =
            (map['checkedItems']?.isEmpty ?? true) ? [] : map['checkedItems'],
        uncheckedItems = (map['uncheckedItems']?.isEmpty ?? true)
            ? []
            : map['uncheckedItems'],
        cycle = map['cycle'],
        unit = map['unit'],
        startAt = map['startAt'],
        nextStartAt = calculateDuration(
            (map['unit'].toString().replaceAll('CycleUnit.', '')),
            map['cycle'],
            map['startAt']),
        specName = map['specName'];

  Map<String, dynamic> get asMap {
    return <String, dynamic>{
      'name': name,
      'checkedItems': checkedItems,
      'uncheckedItems': uncheckedItems,
      'cycle': cycle,
      'unit': unit.name,
      'startAt': startAt,
      'nextStartAt': nextStartAt,
      'specName': specName,
    };
  }

  static Future<void> check() async {}

  static Future<void> uncheck() async {}

  static Future<void> achive() async {}

  static Timestamp calculateDuration(
      String unit, int cycle, Timestamp startAt) {
    int microseconds = 0;

    switch (unit) {
      case 'minute':
        microseconds = 60 * 1000 * cycle;
        break;
      case 'hour':
        microseconds = 60 * 60 * 1000 * cycle;
        break;
      case 'day':
        microseconds = 24 * 60 * 60 * 1000 * cycle;
        log('startAt epoch: ${startAt.microsecondsSinceEpoch}, add: $microseconds, final epoch: ${startAt.microsecondsSinceEpoch + microseconds}');
        inspect(Timestamp.fromMicrosecondsSinceEpoch(
            startAt.microsecondsSinceEpoch + microseconds));
        break;
    }
    return Timestamp.fromMicrosecondsSinceEpoch(
        startAt.microsecondsSinceEpoch + microseconds);
  }

  static currentDateValues() {
    DateTime now = DateTime.now().toUtc();
    int currentMonth = now.month;
    int currentYear = now.year;
    int currentDay = now.day;
    return {
      'currentDay': currentDay,
      'currentMonth': currentMonth,
      'currentYear': currentYear,
    };
  }
}

enum CycleUnit {
  minute,
  hour,
  day,
}
