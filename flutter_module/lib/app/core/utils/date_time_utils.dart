import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'logging_service.dart';

class DateTimeUtils {
  //!=============================== Constructor ===============================
  static final DateTimeUtils _singleton = DateTimeUtils._internal();
  factory DateTimeUtils() {
    return _singleton;
  }
  DateTimeUtils._internal();
  //!==================================================
  static String formatDate(String inputDate) {
    return DateFormat('EEEE, dd/MM/y').format(
      DateTime.tryParse(inputDate) ?? DateTime.now(),
    );
  }

  //!==================================================
  static String adjustMeetingTime(
    String stringTime, {
    Duration addedTime = const Duration(minutes: 1),
  }) {
    final currentTime = getDateFromStringAndDate(
      time: stringTime,
      date: DateTime.now(),
    );
    final newTime = currentTime.add(addedTime);
    return getStringFromTime(newTime);
  }
  //!==================================================

  static String formatTime(String inputTime) {
    return DateFormat.jm().format(DateFormat('hh:mm:ss').parse(inputTime));
  }
  //!==================================================

  static DateTime getDateFromString(String? inputDate) {
    return DateTime.tryParse(inputDate ?? '') ?? DateTime.now();
  }

  //!==================================================

  static String getStringFromDate(DateTime? inputDate,
      {String? seperator = '-'}) {
    final date = DateFormat('y${seperator}MM${seperator}dd')
        .format(inputDate ?? DateTime.now());
    return date;
  }

  //!==================================================

  static String getStringFromTime([DateTime? inputTime]) {
    /// API Needs it at this format
    return DateFormat('HH:mm:ss').format(inputTime ?? DateTime.now());
  }
  //!==================================================

  static DateTime getDateFromStringAndDate({
    required String time,
    required DateTime date,
  }) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      int.tryParse(time.split(':')[0]) ?? date.hour,
      int.tryParse(time.split(':')[1]) ?? date.minute,
      int.tryParse(time.split(':')[2]) ?? date.second,
    );
  }

  //!==================================================

  /// To convert [String => TimeOfDay] for the [TimePicker] widget.
  static TimeOfDay getTimeOfDay(String timeString) {
    try {
      // get the current TimeOfDay, from a formatted string that contains
      // the [Hour]:[Minute]:[Seconds]
      var dateTime = DateTime.now();
      return TimeOfDay.fromDateTime(
        DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          int.tryParse(timeString.split(':')[0]) ?? dateTime.hour,
          int.tryParse(timeString.split(':')[1]) ?? dateTime.minute,
          int.tryParse(timeString.split(':')[2]) ?? dateTime.second,
        ),
      );
    } catch (e) {
      LoggingService.error(
        'Error at Method:getTimeOfDay -- Helpersdart',
        [e, StackTrace.current],
      );
      // shit failed, get the [dateTime] of today, and return the desired format
      // of String as the [TimeOfDate] from it.
      return TimeOfDay.fromDateTime((DateTime.now()));
    }
  }

  //!==================================================
  // I won't access this unless one of them is Not null
  static bool hasDatePassed({
    DateTime? dateTime,
    String? dateTimeString,
    String? dateString,
    String? timeString,
  }) {
    try {
      DateTime itemDateTime;
      // try the [DateTime] object
      if (dateTime != null) {
        itemDateTime = dateTime;
      }

      // try the [DateTime as String] object
      else if (dateTimeString != null) {
        itemDateTime = getDateFromString(dateTimeString);
      }

      // try the [DateTime String && Time String] objects.
      else {
        itemDateTime = DateTimeUtils.getDateFromStringAndDate(
          time: timeString!,
          date: DateTimeUtils.getDateFromString(dateString!),
        );
      }

      return itemDateTime.difference(DateTime.now()).inMinutes <= 0;
    } catch (e) {
      LoggingService.error(
        'Error at Method:_getIsMeetingScheduled -- meeting.dart',
        [e],
      );
      return false;
    }
  }
  //!===========================================================================
  //!===========================================================================
}
