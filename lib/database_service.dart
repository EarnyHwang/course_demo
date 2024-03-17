import 'dart:convert';
import 'model/teacher.dart';
import 'model/course.dart';
import 'model/course_time.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseService {
  DatabaseService();

  var db;

  initDatabase({bool insertData = true}) async {
    sqfliteFfiInit();

    var databaseFactory = databaseFactoryFfi;
    db = await databaseFactory.openDatabase(inMemoryDatabasePath);

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
      await initDemoData();
    }
  }

  initDemoData() async {
    await db.insert('Courses', <String, Object?>{
      'title': '基礎程式設計',
      'url':
          'https://class-qry.acad.ncku.edu.tw/syllabus/online_display.php?syear=0112&sem=1&co_no=F711110&class_code=',
      'times': '[{"weekday":1, "start":"08:00", "end":"10:00"}]'
    });

    await db.insert('Courses', <String, Object?>{
      'title': '人工智慧總整與實作',
      'url': 'https://www.csie.ncku.edu.tw/zh-hant/admission/ai',
      'times': '[{"weekday":2, "start":"16:00", "end":"17:00"}]'
    });

    await db.insert('Courses', <String, Object?>{
      'title': '建築概論',
      'url':
          'https://class-qry.acad.ncku.edu.tw/syllabus/online_display.php?syear=0112&sem=1&co_no=E711600&class_code=',
      'times': '[{"weekday":5, "start":"13:30", "end":"16:30"}]'
    });

    await db.insert('Teachers', <String, Object?>{
      'title': 'Professor',
      'name': 'Mishel Stark',
      'image': 'emily',
      'user_id': 1,
      'course_ids': '[1, 2]',
    });

    await db.insert('Teachers', <String, Object?>{
      'title': 'Lecturer',
      'name': 'Leo Wilson',
      'image': 'leo',
      'user_id': 2,
      'course_ids': '[3]',
    });
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

    for (Teacher teacher in teachers) {
      result = await db.query('Courses',
          where:
              "id in (${List.filled(teacher.courseIds.length, '?').join(',')})",
          whereArgs: teacher.courseIds);

      List<Course> c = [];

      result.forEach((r) => {
            c.add(Course(
                r['title'],
                r['url'],
                List<CourseTime>.from(jsonDecode(r['times']).map(
                    (t) => CourseTime(t['weekday'], t['start'], t['end']))),
                id: r['id']))
          });

      teacher.courses = c;
    }

    return teachers;
  }

  Future<int> insertTeacher(Teacher teacher) async {
    var result = await db.insert(
      'Teachers',
      teacher.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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

    return index;
  }

  void updateCourse(Course course) async {
    await db.update('Courses', course.toMap(),
        where: "id = ?", whereArgs: [course.id]);
  }

  void deleteCourse(int courseId) async {
    await db.delete('Courses', where: "id = ?", whereArgs: [courseId]);
  }
}
