import '../databaseService.dart';
import '../model/teacher.dart';
import '../model/course.dart';
import '../model/course_time.dart';
import 'package:test/test.dart';
import 'dart:developer' as developer;

void main() {
  test('insert and get teacher with course data', () async {
    var databaseService = DatabaseService();
    await databaseService.initDatabase(insertData: false);

    CourseTime courseTime = CourseTime(4, "07:00", "12:00");
    List<CourseTime> ctList = [];
    ctList.add(courseTime);
    Course course = Course(
        '論語',
        'https://aries.dyu.edu.tw/~cosh/courses/DirectionOfTheConfucianistClassics/book.htm',
        ctList);
    int index = await databaseService.insertCourse(course);
    var courseDate = await databaseService.getCourses();
    expect(courseDate.length, 1);

    Teacher teacher = Teacher(0, '教授', '孔丘', 'kon', courseIds: [index]);
    teacher.id = await databaseService.insertTeacher(teacher);
    var teacherDate = await databaseService.getTeachers();

    expect(teacherDate.length, 1);
    expect(teacherDate[0].title, teacher.title);

    teacher.courses = await databaseService.getTeacherCourses(teacher.id);

    expect(teacher.courses[0].id, index);
    expect(teacher.courses[0].times[0].weekday, courseTime.weekday);
    databaseService.closeDatabase();
  });

  test('insert, delete and get course data', () async {
    var databaseService = DatabaseService();
    await databaseService.initDatabase(insertData: false);

    CourseTime courseTime = CourseTime(4, "07:00", "12:00");
    List<CourseTime> ctList = [];
    ctList.add(courseTime);
    Course course = Course(
        '論語',
        'https://aries.dyu.edu.tw/~cosh/courses/DirectionOfTheConfucianistClassics/book.htm',
        ctList);
    int index = await databaseService.insertCourse(course);

    databaseService.deleteCourse(index);
    var courseDate = await databaseService.getCourses();
    expect(courseDate.length, 0);

    databaseService.closeDatabase();
  });

  test('insert, update and get course data', () async {
    var databaseService = DatabaseService();
    await databaseService.initDatabase(insertData: false);

    CourseTime courseTime = CourseTime(4, "07:00", "12:00");
    List<CourseTime> ctList = [];
    ctList.add(courseTime);
    Course course = Course(
        '論語',
        'https://aries.dyu.edu.tw/~cosh/courses/DirectionOfTheConfucianistClassics/book.htm',
        ctList);
    int index = await databaseService.insertCourse(course);

    course.id = index;
    course.title = "春秋";

    databaseService.updateCourse(course);
    var courseDate = await databaseService.getCourses();
    expect(courseDate.length, 1);
    expect(courseDate[0].title, course.title);

    databaseService.closeDatabase();
  });
}
