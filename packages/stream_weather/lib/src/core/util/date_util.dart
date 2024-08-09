import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateFormat _datetimeFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");

DateFormat _dateIso8601 = DateFormat('yyyy-MM-dd');

DateFormat _monthIso8601 = DateFormat('yyyy-MM');

extension StringToDatetimeConverter on String? {
  DateTime? toDatetime() => this != null ? _datetimeFormat.parse(this!, true).toLocal() : null;

  DateTime? toUtcDatetime() => this != null ? _datetimeFormat.parse(this!, true) : null;
}

extension DatetimeToStringConverter on DateTime? {
  String? format() => this != null ? _datetimeFormat.format(this!.toUtc()) : null;
}

extension DateToIso8601 on DateTime {
  String toIso8601DateOnlyString() => _dateIso8601.format(this);
}

extension StringToIso8601OnlyDate on String {
  DateTime dateOnlyStringToIso8601Datetime() => _dateIso8601.parse(this, true);
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension StringToIso8601MonthConverter on String? {
  DateTime? toIso8601MonthDatetime() => this != null ? _monthIso8601.parse(this!, true) : null;
}

extension Iso8601MonthToStringConverter on DateTime? {
  String? toIso8601MonthString() => this != null ? _monthIso8601.format(this!) : null;
}

extension LastDayOfMonthExtension on DateTime {
  DateTime getLastDayOfMonth({int monthOffset = 0}) {
    return getFirstDayOfMonth(monthOffset: monthOffset + 1).subtract(const Duration(days: 1));
  }

  DateTime getFirstDayOfMonth({int monthOffset = 0}) => DateTime(year, month + monthOffset);

  DateTime getFirstDayOfWeek({int weekOffset = 0}) {
    return DateUtils.dateOnly(
      subtract(
        Duration(days: weekday - 1 - weekOffset * 7),
      ),
    );
  }
}

int getTimeCycle(int time) {
  int cycledTime;

  // Hanlde cycles
  if (time >= 24) {
    final part = (time / 24).floor() * 24;
    cycledTime = time - part;
  } else if (time < 0) {
    final part = (time.abs() / 24).floor() * 24 + 24;
    cycledTime = time + part;
  } else {
    cycledTime = time;
  }

  if (cycledTime == 24) {
    cycledTime = 0;
  }

  return cycledTime;
}

String showAmPmHoursFrom24HoursFormat(int time) {
  final labels = '12am,1am,2am,3am,4am,5am,6am,7am,8am,9am,10am,11am,'
          '12pm,1pm,2pm,3pm,4pm,5pm,6pm,7pm,8pm,9pm,10pm,11pm'
      .split(',');

  final labelIdx = getTimeCycle(time);
  return labels[labelIdx];
}

String showAmPmTimeFrom24HoursFormat(double time) {
  var hours = getTimeCycle(time.floor());

  if (hours > 12) {
    hours = hours - 12;
  }

  if (hours == 0) {
    hours = 12;
  }

  final minutes = ((time - time.floor()) * 60).round();
  final h = hours < 10 ? '0$hours' : '$hours';
  final m = minutes < 10 ? '0$minutes' : '$minutes';

  return '$h:$m';
}


int timestampInMillisecondsToSeconds(int timestampMilliseconds) {
  var seconds =timestampMilliseconds ~/ 1000;
  return seconds.toInt();
}

