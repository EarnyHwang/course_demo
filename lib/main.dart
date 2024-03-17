import 'package:flutter/material.dart';

import 'database_service.dart';
import 'model/teacher.dart';
import 'widget/teacher_info.dart';

void main() {
  runApp(const MyApp());
}

var databaseService;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '選課系統 Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '選課系統 DEMO'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Teacher> teacherDatas = [];

  _MyHomePageState();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getData();
      setState(() {});
    });
    super.initState();
  }

  _getData() async {
    databaseService = DatabaseService();
    await databaseService.initDatabase();
    teacherDatas = await databaseService.getTeachers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        for (Teacher teacherData in teacherDatas) TeacherInfo(teacherData),
      ]),
    );
  }
}
