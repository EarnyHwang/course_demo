import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class CourseTime {
  int weekday;
  String start;
  String end;

  CourseTime(this.weekday, this.start, this.end);

  Map<String, dynamic> toMap() {
    return {
      'weekday': weekday,
      'start': start,
      'end': end,
    };
  }

  @override
  String toString() {
    return 'CourseTime{weekday: $weekday, start:$start, end:$end}';
  }
}
