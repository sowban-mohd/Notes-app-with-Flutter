import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/core/theme/styles.dart';
import 'package:notetakingapp1/features/note/controller/all_notes_controller.dart';
import 'package:notetakingapp1/features/note/models/note.dart';
import 'package:notetakingapp1/features/note/ui/components/layouts/note_editing_screen_layout.dart';

class NoteEditingscreen extends ConsumerStatefulWidget {
  final Note? note;
  const NoteEditingscreen({super.key, this.note});

  @override
  ConsumerState<NoteEditingscreen> createState() => _NoteEditingscreenState();
}

class _NoteEditingscreenState extends ConsumerState<NoteEditingscreen> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  late String titleText;
  late String contentText;
  late Note note;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      note = widget.note!;
      titleText = widget.note!.title;
      contentText = widget.note!.content;
    } else {
      titleText = '';
      contentText = '';
    }
    titleController = TextEditingController(text: titleText);
    contentController = TextEditingController(text: contentText);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allNotesController = ref.read(allNotesControllerProvider.notifier);

    return NoteEditingScreenLayout(
      onBack: () => Navigator.pop(context),
      onSave: () async {
        if (widget.note == null) {
          await allNotesController.addNote(
              title: titleController.text, content: contentController.text);
        } else {
          await allNotesController.updateNote(note.copyWith(
            title: titleController.text,
            content: contentController.text,
          ));
        }
        if (context.mounted) Navigator.pop(context);
      },
      titleController: titleController,
      contentController: contentController,
      buttonTextStyle: Styles.textButtonStyle(fontSize: 14.0),
      iconColor: colorScheme.primary,
      textSelectionTheme: Styles.textSelectionTheme(),
      backgroundColor: colorScheme.surfaceContainerLowest,
    );
  }
}
