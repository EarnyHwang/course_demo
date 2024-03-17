import '../model/course.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

var weekdayMap = {
  1: '一',
  2: '二',
  3: '三',
  4: '四',
  5: '五',
  6: '六',
  7: '日',
};

class CourseInfo extends StatefulWidget {
  const CourseInfo(this.courseData, {super.key});

  final Course courseData;

  @override
  State<CourseInfo> createState() => _CourseInfo(courseData);
}

class _CourseInfo extends State<CourseInfo> {
  _CourseInfo(this.courseData);
  Course courseData;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Align(
              child: Container(
                  margin: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                  child: const Icon(
                    Icons.calendar_month,
                    color: Colors.grey,
                  ))),
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Text(courseData.title),
                Text(
                    '每周${weekdayMap[courseData.times[0].weekday]}，${courseData.times[0].start} ~ ${courseData.times[0].end}')
              ])),
          Align(
              child: Container(
                  margin: const EdgeInsets.all(15),
                  child: IconButton(
                    icon: const Icon(Icons.navigate_next),
                    onPressed: () {
                      _launchUrl(courseData.url);
                    },
                  )))
        ]);
  }

  void _launchUrl(String url) async {
    await launchUrl(Uri.parse(url));
  }
}
