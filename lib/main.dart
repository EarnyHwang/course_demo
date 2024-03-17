import 'dart:io';
import 'databaseService.dart';
import 'model/teacher.dart';
import 'model/course.dart';
import 'model/course_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:developer' as developer;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

var databaseService;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Demo',
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
  bool isExpanded = false;

  _MyHomePageState() {
    databaseService = DatabaseService();
    databaseService.initDatabase();
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
        Card(
            color: Colors.white,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                side: !isExpanded
                    ? BorderSide.none
                    : BorderSide(width: 0.5, color: Colors.black)),
            child: ExpansionTile(
              backgroundColor: Colors.transparent,
              collapsedIconColor: Colors.black,
              iconColor: Colors.black,
              collapsedShape: RoundedRectangleBorder(
                side: BorderSide.none,
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide.none,
              ),
              onExpansionChanged: (bool expanded) {
                setState(() {
                  isExpanded = expanded;
                });
              },
              title: Text(
                'title',
                style: TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.normal),
              ),
              subtitle: Text('subtitle',
                  style: TextStyle(
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
                      (!kIsWeb ? 'assets/' : '') + 'png/' + 'emily' + '.png')),
              children: <Widget>[
                const Divider(
                  height: 5,
                  thickness: 0.1,
                  indent: 15,
                  endIndent: 15,
                  color: Colors.black,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Align(
                          child: Container(
                              margin: EdgeInsets.fromLTRB(15, 0, 10, 0),
                              child: Icon(
                                Icons.calendar_month,
                                color: Colors.grey,
                              ))),
                      Expanded(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                            Text('基礎程式設計'),
                            Text('每周二，10:00 ~ 12:00')
                          ])),
                      Align(
                          child: Container(
                              margin: EdgeInsets.all(15),
                              child: IconButton(
                                icon: Icon(Icons.navigate_next),
                                onPressed: () {
                                  _launchUrl('https://www.google.com/');
                                },
                              )))
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Align(
                          child: Container(
                              margin: EdgeInsets.fromLTRB(15, 0, 10, 0),
                              child: Icon(
                                Icons.calendar_month,
                                color: Colors.grey,
                              ))),
                      Expanded(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                            Text('基礎程式設計'),
                            Text('每周二，10:00 ~ 12:00')
                          ])),
                      Align(
                          child: Container(
                              margin: EdgeInsets.all(15),
                              child: IconButton(
                                icon: Icon(Icons.navigate_next),
                                onPressed: () {
                                  _launchUrl('https://www.google.com/');
                                },
                              )))
                    ]),
              ],
            ))
      ]),
    );
  }

  void _launchUrl(String url) async {
    await launchUrl(Uri.parse(url));
  }
}
