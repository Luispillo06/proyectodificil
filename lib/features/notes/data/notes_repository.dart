import 'package:proyectodificil/core/models/note.dart';
import 'package:proyectodificil/core/database/note_dao.dart';

abstract class NotesRepository {
  Future<List<Note>> getAllNotes();
  Future<Note?> getNoteById(int id);
  Future<Note> createNote(Note note);
  Future<void> updateNote(Note note);
  Future<void> deleteNote(int id);
}

class NotesRepositoryImpl implements NotesRepository {
  final NoteDao _noteDao = NoteDao();

  @override
  Future<List<Note>> getAllNotes() async {
    return _noteDao.getAllNotes();
  }

  @override
  Future<Note?> getNoteById(int id) async {
    return _noteDao.getNoteById(id);
  }

  @override
  Future<Note> createNote(Note note) async {
    return _noteDao.insertNote(note);
  }

  @override
  Future<void> updateNote(Note note) async {
    return _noteDao.updateNote(note);
  }

  @override
  Future<void> deleteNote(int id) async {
    return _noteDao.deleteNote(id);
  }
}
