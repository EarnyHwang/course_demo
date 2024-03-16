import 'course.dart';
import '../databaseService.dart';

class Teacher {
  int? id;
  int userId;
  String title;
  String name;
  String image;
  List<int> courseIds;
  List<Course> courses;

  Teacher(this.userId, this.title, this.name, this.image,
      {this.id, this.courseIds = const [], this.courses = const []});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'title': title,
      'image': image,
      'course_ids': courseIds.toString(),
    };
  }

  @override
  String toString() {
    return 'Teacher{id: $id, user_id:$userId, name: $name, title: $title, image: $image, courseIds:$courseIds, courses: $courses}';
  }
}
