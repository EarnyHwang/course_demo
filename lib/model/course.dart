import 'dart:convert';
import 'course_time.dart';

class Course {
  int? id;
  String title;
  String url;
  List<CourseTime> times;

  Course(this.title, this.url, this.times, {this.id});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'times': [
        for (var t in times)
          {
            '"weekday"': t.weekday,
            '"start"': '"${t.start}"',
            '"end"': '"${t.end}"'
          }
      ].toString()
    };
  }

  @override
  String toString() {
    return 'Course{id: $id, title:$title, url: $url, times:$times}';
  }
}
