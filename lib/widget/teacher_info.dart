import 'course_info.dart';
import '../model/teacher.dart';
import '../model/course.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class TeacherInfo extends StatefulWidget {
  const TeacherInfo(this.teacherData, {super.key});

  final Teacher teacherData;

  @override
  State<TeacherInfo> createState() => _TeacherInfo(teacherData);
}

class _TeacherInfo extends State<TeacherInfo> {
  _TeacherInfo(this.teacherData);
  bool isExpanded = false;
  Teacher teacherData;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            side: !isExpanded
                ? BorderSide.none
                : const BorderSide(width: 0.5, color: Colors.black)),
        child: ExpansionTile(
          backgroundColor: Colors.transparent,
          collapsedIconColor: Colors.black,
          iconColor: Colors.black,
          collapsedShape: const RoundedRectangleBorder(
            side: BorderSide.none,
          ),
          shape: const RoundedRectangleBorder(
            side: BorderSide.none,
          ),
          onExpansionChanged: (bool expanded) {
            setState(() {
              isExpanded = expanded;
            });
          },
          title: Text(
            teacherData.title,
            style: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.normal),
          ),
          subtitle: Text(teacherData.name,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w600)),
          trailing: !isExpanded
              ? const Icon(
                  Icons.add,
                )
              : const Icon(
                  Icons.remove,
                ),
          leading: CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(
                  '${!kIsWeb ? 'assets/' : ''}png/${teacherData.image}.png')),
          children: <Widget>[
            const Divider(
              height: 5,
              thickness: 0.1,
              indent: 15,
              endIndent: 15,
              color: Colors.black,
            ),
            for (Course course in teacherData.courses) CourseInfo(course),
          ],
        ));
  }
}
