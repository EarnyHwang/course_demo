import 'course.dart';

class Student {
  int? id;
  int userId;
  String name;
  List<int> courseIDs = [];
  List<Course>? courses;

  Student(this.userId, this.name, {this.id});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'courseIDs': courseIDs.toString(),
    };
  }

  @override
  String toString() {
    return 'Student{id: $id, user_id:$userId, name: $name, courseIDs: $courseIDs}';
  }
}
