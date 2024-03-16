import 'dart:convert';
import 'dart:ffi';
import 'model/teacher.dart';
import 'model/course.dart';
import 'model/course_time.dart';
//import 'main.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:developer' as developer;

class Db {
  Db();

  var db;

  initDatabase({bool insertData = true}) async {
    //print("initDatabase");

    sqfliteFfiInit();

    //print("sqfliteFfiInit");

    var databaseFactory = databaseFactoryFfi;
    db = await databaseFactory.openDatabase(inMemoryDatabasePath);

    //print("sqfliteFfiInit DB open");

    await db.execute('''
      CREATE TABLE Users (
          id INTEGER PRIMARY KEY,
          account TEXT,
          password TEXT
      )''');
    await db.execute('''
      CREATE TABLE Teachers (
        id INTEGER PRIMARY KEY,
        user_id INTEGER,
        title TEXT,
        name TEXT,
        image TEXT,
        course_ids REAL
      )''');
    await db.execute('''
      CREATE TABLE Students (
        id INTEGER PRIMARY KEY,
        user_id INTEGER,
        name TEXT,
        courses REAL
      )''');
    await db.execute('''
      CREATE TABLE Courses (
        id INTEGER PRIMARY KEY,
        title TEXT,
        url TEXT,
        times REAL
      )''');

    if (insertData) {
      //print("true");
      initDemoData();
    } else {
      //print("false");
    }

    //print("initDatabase end");
  }

  void initDemoData() async {
    await db.insert('Courses', <String, Object?>{
      'title': 'title',
      'url': 'url',
      'times': '[{"weekday":1, "start":"08:00", "end":"10:00"}]'
    });

    await db.insert('Courses', <String, Object?>{
      'title': 'title2',
      'url': 'url2',
      'times': '[{"weekday":2, "start":"08:00", "end":"10:00"}]'
    });
/*
    var result = await db.query('Courses');
    developer.log(result.toString());
*/
/*
    await db.insert('Users', <String, Object?>{
      'id': 1,
      'account': 'account',
      'password': 'password'
    });
*/
    await db.insert('Teachers', <String, Object?>{
      'title': 'title',
      'name': 'name',
      'image': 'image',
      'user_id': 1,
      'course_ids': '[2]',
    });
/*
    var result = await db.query('Users');
    developer.log(result.toString());
*/
    var result = await db.query('Teachers');
    //print(result.toString());
//    await db.close();
  }

  void closeDatabase() async {
    await db.close();
  }

  void deleteAllData() async {
    await db.delete('users');
    await db.delete('teachers');
    await db.delete('students');
    await db.delete('courses');
  }

  Future<List<Teacher>> getTeachers() async {
    var result = await db.query('Teachers');

    List<Teacher> teachers = [];
    result.forEach((r) => {
          teachers.add(Teacher(r['user_id'], r['title'], r['name'], r['image'],
              id: r['id'],
              courseIds:
                  List<int>.from(jsonDecode(r['course_ids']).map((i) => i))))
        });

    return teachers;
  }

  Future<int> insertTeacher(Teacher teacher) async {
    var result = await db.insert(
      'Teachers',
      teacher.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    developer.log(result.toString());

    return result;
  }

  Future<List<Course>> getTeacherCourses(int? teacherId) async {
    if (teacherId == null) {
      return [];
    }

    var result =
        await db.query('Teachers', where: "id = ?", whereArgs: [teacherId]);

    result = await db.query('Courses',
        where:
            "id in (${List.filled(jsonDecode(result[0]["course_ids"]).length, '?').join(',')})",
        whereArgs: jsonDecode(result[0]["course_ids"]));

    List<Course> courses = [];

    //print(result.toString());

    result.forEach((r) => {
          courses.add(Course(
              r['title'],
              r['url'],
              List<CourseTime>.from(jsonDecode(r['times'])
                  .map((t) => CourseTime(t['weekday'], t['start'], t['end']))),
              id: r['id']))
        });

    return courses;
  }

  Future<List<Course>> getCourses() async {
    var result = await db.query('Courses');

    List<Course> courses = [];
    result.forEach((r) => {
          courses.add(Course(
            r['title'],
            r['url'],
            List<CourseTime>.from(jsonDecode(r['times'])
                .map((t) => CourseTime(t['weekday'], t['start'], t['end']))),
            id: r['id'],
          ))
        });

    return courses;
  }

  Future<int> insertCourse(Course course, {int teacherId = -1}) async {
    //print(course.toMap().toString());

    var index = await db.insert(
      'Courses',
      course.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    if (teacherId != -1) {
      var t = await db.query(
        'Teachers',
        where: "id = ?",
        whereArgs: [teacherId],
        limit: 1,
      );

      Iterable l = jsonDecode(t[0]['course_ids']);
      List<int> courseIds = List<int>.from(l.map((int) => int));

      courseIds.add(index);

      await db.update('Teachers', {'course_ids': courseIds.toString()},
          where: "id = ?", whereArgs: [teacherId]);
    }

    var result = await db.query('Courses');
    developer.log(result.toString());
    result = await getCourses();
    developer.log(result.toString());

    return index;
  }

  void updateCourse(Course course) async {
    await db.update('Courses', course.toMap(),
        where: "id = ?", whereArgs: [course.id]);
  }

  void deleteCourse(int courseId) async {
    await db.delete('Courses', where: "id = ?", whereArgs: [courseId]);

    var result = await db.query('Courses');
    developer.log(result.toString());
  }
}
