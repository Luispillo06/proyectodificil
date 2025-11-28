import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyectodificil/core/models/note.dart';
import 'package:proyectodificil/features/notes/data/notes_repository.dart';
import 'package:proyectodificil/core/services/ai_service.dart';

final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  return NotesRepositoryImpl();
});

final aiServiceProvider = Provider<AiService>((ref) {
  return AiServiceImpl();
});

class NotesNotifier extends StateNotifier<AsyncValue<List<Note>>> {
  final NotesRepository repository;

  NotesNotifier(this.repository) : super(const AsyncValue.loading()) {
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      state = const AsyncValue.loading();
      final notes = await repository.getAllNotes();
      state = AsyncValue.data(notes);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createNote(String title, String content) async {
    try {
      final newNote = Note(
        title: title,
        content: content,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await repository.createNote(newNote);
      await _loadNotes();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateNote(int id, String title, String content) async {
    try {
      final updatedNote = Note(
        id: id,
        title: title,
        content: content,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await repository.updateNote(updatedNote);
      await _loadNotes();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      await repository.deleteNote(id);
      await _loadNotes();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refreshNotes() async {
    await _loadNotes();
  }
}

final notesProvider = StateNotifierProvider<NotesNotifier, AsyncValue<List<Note>>>(
  (ref) {
    final repository = ref.watch(notesRepositoryProvider);
    return NotesNotifier(repository);
  },
);

final noteByIdProvider = FutureProvider.family<Note?, int>((ref, id) async {
  final repository = ref.watch(notesRepositoryProvider);
  return repository.getNoteById(id);
});

final generateSummaryProvider = FutureProvider.family<String, String>((ref, content) async {
  final aiService = ref.watch(aiServiceProvider);
  return aiService.generateSummary(content);
});

final improveTextProvider = FutureProvider.family<String, String>((ref, text) async {
  final aiService = ref.watch(aiServiceProvider);
  return aiService.improveText(text);
});
