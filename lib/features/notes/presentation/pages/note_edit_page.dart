import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proyectodificil/features/notes/providers/notes_provider.dart';

class NoteEditPage extends ConsumerStatefulWidget {
  final String? noteId;

  const NoteEditPage({Key? key, this.noteId}) : super(key: key);

  @override
  ConsumerState<NoteEditPage> createState() => _NoteEditPageState();
}

class _NoteEditPageState extends ConsumerState<NoteEditPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.noteId != null;
    final noteAsync = isEditing 
        ? ref.watch(noteByIdProvider(int.parse(widget.noteId!)))
        : const AsyncValue.data(null);

    if (isEditing) {
      noteAsync.whenData((note) {
        if (note != null && _titleController.text.isEmpty) {
          _titleController.text = note.title;
          _contentController.text = note.content;
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Nota' : 'Crear Nueva Nota'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Título',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: 'Contenido (escribe tu nota aquí...)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                maxLines: 8,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_titleController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('El título no puede estar vacío')),
                          );
                          return;
                        }

                        if (isEditing) {
                          await ref.read(notesProvider.notifier).updateNote(
                            int.parse(widget.noteId!),
                            _titleController.text,
                            _contentController.text,
                          );
                        } else {
                          await ref.read(notesProvider.notifier).createNote(
                            _titleController.text,
                            _contentController.text,
                          );
                        }

                        if (context.mounted) {
                          context.pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isEditing ? 'Nota actualizada' : 'Nota creada',
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(isEditing ? 'Actualizar' : 'Guardar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      child: const Text('Cancelar'),
                    ),
                  ),
                ],
              ),
              if (_contentController.text.isNotEmpty) ...[
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Funciones de IA',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Función de resumen no configurada. Agrega tu API key de IA.'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.summarize),
                      label: const Text('Resumir nota'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Función de mejora no configurada. Agrega tu API key de IA.'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.auto_fix_high),
                      label: const Text('Mejorar texto'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
