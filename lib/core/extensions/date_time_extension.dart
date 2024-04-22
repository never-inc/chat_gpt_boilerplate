import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String format({
    String format = 'yyyy/MM/dd HH:mm:ss',
    String locale = 'ja_JP',
  }) {
    final formatter = DateFormat(format, locale);
    return formatter.format(this);
  }

  DateTime setHour(
    int hour, [
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  ]) =>
      DateTime(
        year,
        month,
        day,
        hour,
        minute ?? this.minute,
        second ?? this.second,
        millisecond ?? this.millisecond,
        microsecond ?? this.microsecond,
      );
}
