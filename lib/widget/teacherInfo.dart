import 'package:flutter/material.dart';

class TeacherInfo {
  BuildContext _context;

  TeacherInfo._create(this._context);

  factory TeacherInfo.of(BuildContext context) {
    return TeacherInfo._create(context);
  }
}

class _TeacherInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TeacherInfoWidget();
}

class _TeacherInfoWidget extends State<_TeacherInfo> {
  @override
  Widget build(BuildContext context) {
    return Center();
  }
}
