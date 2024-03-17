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
}
