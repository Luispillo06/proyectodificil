import 'package:sqflite/sqflite.dart';
import 'package:proyectodificil/core/models/note.dart';
import 'app_database.dart';

class NoteDao {
  static final NoteDao _instance = NoteDao._internal();

  factory NoteDao() {
    return _instance;
  }

  NoteDao._internal();

  Future<Note> insertNote(Note note) async {
    final db = await AppDatabase.instance.database;
    final id = await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return note.copyWith(id: id);
  }

  Future<void> updateNote(Note note) async {
    final db = await AppDatabase.instance.database;
    await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteNote(int id) async {
    final db = await AppDatabase.instance.database;
    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Note?> getNoteById(int id) async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Note>> getAllNotes() async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query('notes', orderBy: 'updatedAt DESC');
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }
}
