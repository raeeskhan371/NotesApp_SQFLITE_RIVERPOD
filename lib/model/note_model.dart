class NoteModel {
  int? id;
  String title;
  String description;

  NoteModel({this.id, required this.title, required this.description});

  Map<String, dynamic> toMap() {
    return {"id": id, "title": title, "description": description};
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map["id"],
      title: map["title"],
      description: map["description"],
    );
  }
}
