import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class CourseTime {
  //final int id;
  //final int courseId;
  int weekday;
  String start;
  String end;

  CourseTime(/*this.id, this.courseId,*/ this.weekday, this.start, this.end);

  Map<String, dynamic> toMap() {
    return {
      //'id': id,
      //'course_id': courseId,
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
