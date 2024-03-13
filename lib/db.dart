import 'teacher.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:developer' as developer;

class Db {
  var db;

  Db() {
    openDatabase();
  }

  openDatabase() async {
    var databasesPath = await getDatabasesPath();
    developer.log(databasesPath);

    try {
      await Directory(databasesPath).create(recursive: true);
    } catch (_) {}

    db = openDatabase();
  }

  Future<void> insertTeacher(Teacher teacher) async {
    final Database database = await db;

    await database.insert(
      'teachers',
      teacher.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
