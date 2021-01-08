import 'package:intl/intl.dart';

DateTime getTimeFromString(String str, DateTime now){
  DateTime time = DateFormat('HH:mm').parse(str);
  return DateTime(now.year, now.month, now.day, time.hour, time.minute);
}

DateTime getDateTimeFromString(String str, int hour){
  DateTime day = DateFormat('yyyy/MM/dd').parse(str);
  return DateTime(day.year, day.month, day.day, hour, 0);
}

