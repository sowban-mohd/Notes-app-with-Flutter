import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/features/notes/controller/all_notes_controller.dart';
import 'package:notetakingapp1/core/theme/styles.dart';
import 'package:notetakingapp1/features/notes/controller/folders_controller.dart';
import 'package:notetakingapp1/features/notes/models/note.dart';
import 'package:notetakingapp1/features/notes/ui/components/layouts/note_editing_screen_layout.dart';

class FolderNoteEditingScreen extends ConsumerStatefulWidget {
  final Note? note;
  const FolderNoteEditingScreen({
    super.key,
    this.note,
  });

  @override
  ConsumerState<FolderNoteEditingScreen> createState() =>
      _FolderNoteEditingScreenState();
}

class _FolderNoteEditingScreenState
    extends ConsumerState<FolderNoteEditingScreen> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  late String titleText;
  late String contentText;
  late String? folderId;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleText = widget.note!.title;
      contentText = widget.note!.content;
    } else {
      titleText = '';
      contentText = '';
    }
    folderId = ref.read(currentlyClickedFolderProvider);
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
    final notesController = ref.read(allNotesControllerProvider.notifier);
    final foldersController = ref.read(foldersControllerProvider.notifier);

    return NoteEditingScreenLayout(
      onBack: () => Navigator.pop(context),
      onSave: () async {
        if (widget.note == null) {
          await foldersController.addInFolder(
              titleController.text, contentController.text, folderId!);
        } else {
          final note = Note(
              title: titleController.text,
              content: contentController.text,
              id: widget.note!.id,
              pinned: widget.note!.pinned,
              folderRefs: []);
          await notesController.updateNote(note);
        }
        if (context.mounted) Navigator.pop(context);
      },
      titleController: titleController,
      contentController: contentController,
      buttonTextStyle:
          Styles.boldTexts(fontSize: 16.0, color: Color(0xFFA67B5B)),
      iconColor: Color(0xFFA67B5B),
      textSelectionTheme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0xFFA67B5B),
          selectionColor: Color(0xFFA67B5B).withAlpha(51),
          selectionHandleColor: Color(0xFFA67B5B),
        ),
      ),
      backgroundColor: colorScheme.surfaceContainerLowest,
    );
  }
}
