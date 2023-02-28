class NoteModel {
  final int? id;
  final String title;
  final String des;

  NoteModel({this.id, required this.title, required this.des});

  NoteModel.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        des = res["des"];

  Map<String, Object?> toMap() {
    return {"id": id, "title": title, "des": des};
  }
}
