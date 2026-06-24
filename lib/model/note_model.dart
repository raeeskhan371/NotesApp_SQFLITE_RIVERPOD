class NoteModel {
  String title;
  String description;
  int? id;

  NoteModel({required this.title, required this.description, this.id});

  // Map
  Map<String, dynamic> toMap() {
    return {"title": title, "description": description};
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map["S_NO"],
      title: map["title"],
      description: map["description"],
    );
  }
}
