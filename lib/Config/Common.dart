import 'package:intl/intl.dart';

DateTime getTimeFromString(String str, DateTime now){
  DateTime time = DateFormat('HH:mm').parse(str);
  return DateTime(now.year, now.month, now.day, time.hour, time.minute);
}
