import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/core/constants/notetype.dart';
import 'package:notetakingapp1/features/note/controller/category_provider.dart';
import 'package:notetakingapp1/features/note/controller/folders_controller.dart';
import 'package:notetakingapp1/features/note/controller/selected_folders_controller.dart';
import 'package:notetakingapp1/features/note/controller/selected_notes_controller.dart';
import 'package:notetakingapp1/features/note/ui/screens/folder_note_editing_screen.dart';
import 'package:notetakingapp1/features/note/ui/screens/note_editing_screen.dart';
import 'package:notetakingapp1/core/theme/styles.dart';
import 'package:notetakingapp1/features/note/ui/components/widgets/save_folder_bottom_sheet.dart';

class HomeFAB extends ConsumerWidget {
  const HomeFAB({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedNotes =
        ref.watch(selectedNotesControllerProvider(NoteType.allNotes));
    final selectedFolders = ref.watch(selectedFoldersControllerProvider);
    final selectedFolderNotes = ref.watch(selectedFoldersControllerProvider);
    final isAFolderClicked = ref
        .watch(currentlyClickedFolderProvider.select((state) => state != null));

    // Hide FAB based on selection
    final shouldHideFAB = (selectedNotes.isNotEmpty) ||
        (selectedFolders.isNotEmpty) ||
        (selectedFolderNotes.isNotEmpty);

    if (shouldHideFAB) {
      return const SizedBox.shrink();
    }

    final category = ref.watch(categoryProvider);
    final isAllNotesCategory = category == Category.allNotes.categoryName;
    final isFoldersCategory = category == Category.folders.categoryName;

    return Padding(
        padding: const EdgeInsets.only(bottom: 12.0, right: 6.0),
        child: FloatingActionButton(
          tooltip: isFoldersCategory
              ? 'Create a new folder'
              : isAFolderClicked
                  ? 'Create a new note'
                  : 'Create a new note',
          onPressed: () {
            if (isAllNotesCategory) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteEditingscreen(),
                ),
              );
            } else if (isAFolderClicked) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FolderNoteEditingScreen(),
                  ));
            } else {
              showSaveFolderSheet(context: context);
            }
          },
          elevation: 2.0,
          backgroundColor: isAllNotesCategory
              ? colorScheme.primary
              : const Color(0xFFA67B5B),
          child: Icon(
            isAllNotesCategory || isAFolderClicked ? Icons.edit : Icons.create_new_folder,
            color: colorScheme.onPrimary,
          ),
        ));
  }
}
