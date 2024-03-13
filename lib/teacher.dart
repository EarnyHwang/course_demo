class Teacher {
  final int id;
  final String title;
  final String name;
  final String image;

  Teacher(this.id, this.title, this.name, this.image);

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'title': title, 'image': image};
  }

  @override
  String toString() {
    return 'Teacher{id: $id, name: $name, title: $title, image: $image}';
  }
}
