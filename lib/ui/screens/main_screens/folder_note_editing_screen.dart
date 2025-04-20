import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/logic/providers/home_screen/category_provider.dart';
import 'package:notetakingapp1/logic/providers/folder_notes_category/folder_notes_ops_state_provider.dart';
import 'package:notetakingapp1/logic/providers/all_notes_category/note_ops_state_provider.dart';
import 'package:notetakingapp1/ui/reusable_screen_layouts/note_editing_screen_layout.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';

class FolderNoteEditingScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? note;
  const FolderNoteEditingScreen({super.key, this.note});

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
  late String folder;
  String? noteId;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleText = widget.note!['title'];
      contentText = widget.note!['content'];
      noteId = widget.note!['noteId'];
    } else {
      titleText = '';
      contentText = '';
    }
    folder = ref.read(categoryProvider);
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
    final folderNoteOpsNotifier =
        ref.read(folderNotesOpsProvider(folder).notifier);

    return NoteEditingScreenLayout(
      onBack: () => Navigator.pop(context),
      onSave: () async {
        if (noteId == null) {
          await noteOpsNotifier.addNote(
              title: titleController.text, content: contentController.text);
          await folderNoteOpsNotifier.addToFolder(
            title: titleController.text,
            content: contentController.text,
          );
        } else {
          await noteOpsNotifier.updateNote(
              title: titleController.text,
              content: contentController.text,
              noteId: noteId!);
          await folderNoteOpsNotifier.updateInFolder(
              title: titleController.text,
              content: contentController.text,
              noteId: noteId!);
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
