import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/logic/providers/all_notes_category/note_ops_state_provider.dart';
import 'package:notetakingapp1/ui/reusable_screen_layouts/note_editing_screen_layout.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';

class NoteEditingscreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? note;
  const NoteEditingscreen({super.key, this.note});

  @override
  ConsumerState<NoteEditingscreen> createState() => _NoteEditingscreenState();
}

class _NoteEditingscreenState extends ConsumerState<NoteEditingscreen> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  late String titleText;
  late String contentText;
  String? noteId;
  bool? pinned;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleText = widget.note!['title'];
      contentText = widget.note!['content'];
      noteId = widget.note!['noteId'];
      pinned = widget.note!['pinned'];
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
    final noteOpsNotifier = ref.read(noteOpsStateProvider.notifier);

    return NoteEditingScreenLayout(
      onBack: () => Navigator.pop(context),
      onSave: () async {
        if (noteId == null) {
          await noteOpsNotifier.addNote(
              title: titleController.text, content: contentController.text);
        } else {
          await noteOpsNotifier.updateNote(
              title: titleController.text,
              content: contentController.text,
              noteId: noteId!,
              pinned: pinned!);
        }
        if (context.mounted) Navigator.pop(context);
      },
      titleController: titleController,
      contentController: contentController,
      titleTextStyle:
          Styles.titleStyle(fontSize: 24.0, color: colorScheme.onSurface),
      titleHintStyle: Styles.titleStyle(
          fontSize: 24.0, color: colorScheme.onSurface.withAlpha(66)),
      contentTextStyle:
          Styles.w400texts(fontSize: 16.0, color: colorScheme.onSurface),
      contentHintStyle: Styles.w400texts(
          fontSize: 16.0, color: colorScheme.onSurface.withAlpha(66)),
      buttonTextStyle: Styles.textButtonStyle(fontSize: 16.0),
      iconColor: colorScheme.primary,
      textSelectionTheme: Styles.textSelectionTheme(),
      backgroundColor: colorScheme.surfaceContainerLowest,
    );
  }
}
