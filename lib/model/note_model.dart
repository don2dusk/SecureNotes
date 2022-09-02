final String tableNotes = 'notes';

class NoteFields {
  static final List<String> values = [id, title, body, creationDate];

  static final String id = 'id';
  static final String title = 'title';
  static final String body = 'body';
  static final String creationDate = 'creationDate';
}

class NoteModel {
  final int? id;
  final String title;
  final String body;
  final String creationDate;

  NoteModel(
      {this.id,
      required this.title,
      required this.body,
      required this.creationDate});

  NoteModel copy(
          {int? id, String? title, String? body, String? creationDate}) =>
      NoteModel(
          id: id ?? this.id,
          title: title ?? this.title,
          body: body ?? this.body,
          creationDate: creationDate ?? this.creationDate);

  static NoteModel fromJson(Map<String, Object?> json) => NoteModel(
      id: json[NoteFields.id] as int?,
      title: json[NoteFields.title] as String,
      body: json[NoteFields.body] as String,
      creationDate: json[NoteFields.creationDate] as String);

  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.title: title,
        NoteFields.body: body,
        NoteFields.creationDate: creationDate
      };
}
