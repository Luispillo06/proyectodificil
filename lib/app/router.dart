import 'package:go_router/go_router.dart';
import 'package:proyectodificil/features/notes/presentation/pages/notes_list_page.dart';
import 'package:proyectodificil/features/notes/presentation/pages/note_edit_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const NotesListPage(),
      routes: [
        GoRoute(
          path: 'create',
          builder: (context, state) => const NoteEditPage(),
        ),
        GoRoute(
          path: 'edit/:id',
          builder: (context, state) {
            final id = state.pathParameters['id'];
            return NoteEditPage(noteId: id);
          },
        ),
      ],
    ),
  ],
);