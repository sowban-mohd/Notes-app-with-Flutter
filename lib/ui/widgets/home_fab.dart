import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/logic/providers/home_screen/category_provider.dart';
import 'package:notetakingapp1/logic/providers/folder_notes_category/folder_notes_selection_provider.dart';
import 'package:notetakingapp1/logic/providers/folders_category/folder_selection_provider.dart';
import 'package:notetakingapp1/logic/providers/all_notes_category/note_selection_provider.dart';
import 'package:notetakingapp1/ui/screens/main_screens/folder_note_editing_screen.dart';
import 'package:notetakingapp1/ui/screens/main_screens/note_editing_screen.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';
import 'package:notetakingapp1/ui/widgets/folders_category/save_folder_bottom_sheet.dart';

class HomeFAB extends ConsumerWidget {
  const HomeFAB({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(categoryProvider);
    final selectedNotes = ref.watch(noteSelectionProvider(NoteType.all));
    final selectedFolders = ref.watch(folderSelectionProvider);
    final selectedFolderNotes = ref.watch(folderNoteSelectionProvider);

    // Hide FAB based on selection
    final shouldHideFAB =
        (category == 'All Notes' && selectedNotes.isNotEmpty) ||
            (category == 'Folders' && selectedFolders.isNotEmpty) ||
            (category != 'All Notes' && category != 'Folders' && selectedFolderNotes.isNotEmpty);

    if (shouldHideFAB) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, right: 6.0),
      child: FloatingActionButton(
        tooltip:
            category == 'Folders' ? 'Create a new folder' : 'Create a new note',
        onPressed: () {
          if (category == 'All Notes') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoteEditingscreen(),
              ),
            );
          } else if (category == 'Folders') {
            showSaveFolderSheet(context: context);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FolderNoteEditingScreen(),
              ),
            );
          }
        },
        elevation: 2.0,
        backgroundColor: category == 'All Notes'
            ? colorScheme.primary
            : const Color(0xFFA67B5B),
        child: Icon(
          category == 'Folders' ? Icons.create_new_folder : Icons.edit,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }
}
