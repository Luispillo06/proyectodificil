import 'package:flutter/material.dart';

class NoteForm extends StatefulWidget {
  final String? initialTitle;
  final String? initialContent;
  final Function(String title, String content) onSubmit;
  final String submitButtonText;

  const NoteForm({
    Key? key,
    this.initialTitle,
    this.initialContent,
    required this.onSubmit,
    this.submitButtonText = 'Guardar',
  }) : super(key: key);

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _contentController = TextEditingController(text: widget.initialContent);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
            labelText: 'Título',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: TextField(
            controller: _contentController,
            decoration: InputDecoration(
              labelText: 'Contenido',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            maxLines: null,
            expands: true,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            widget.onSubmit(
              _titleController.text,
              _contentController.text,
            );
          },
          child: Text(widget.submitButtonText),
        ),
      ],
    );
  }
}
