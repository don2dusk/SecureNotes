import 'package:secure_notes/model/note_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SecureNotesDB {
  static final SecureNotesDB instance = SecureNotesDB._init();
  static Database? _database;
  SecureNotesDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('secureNotes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute(
        '''
      CREATE TABLE $tableNotes(
        ${NoteFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${NoteFields.title} TEXT NOT NULL,
        ${NoteFields.body} TEXT NOT NULL,
        ${NoteFields.creationDate} TEXT NOT NULL
        )
''');
  }

  Future<NoteModel> create(NoteModel note) async {
    final db = await instance.database;

    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.body}, ${NoteFields.creationDate}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.body]}, ${json[NoteFields.creationDate]}';

    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  Future<NoteModel> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return NoteModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<NoteModel>> readAllNotes() async {
    final db = await instance.database;
    final result = await db.query(tableNotes);

    return result.map((json) => NoteModel.fromJson(json)).toList();
  }

  Future<int> update(NoteModel note) async {
    final db = await instance.database;

    return db.update(tableNotes, note.toJson(),
        where: '${NoteFields.id} = ?', whereArgs: [note.id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    _database = null;
    return db.close();
  }
}
