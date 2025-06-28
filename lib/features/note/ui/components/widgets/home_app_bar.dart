import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/core/constants/notetype.dart';
import 'package:notetakingapp1/features/note/controller/selected_folders_controller.dart';
import 'package:notetakingapp1/features/note/controller/selected_notes_controller.dart';
import 'package:notetakingapp1/features/note/ui/components/widgets/app_bar_with_all_notes_ops.dart';
import 'package:notetakingapp1/features/note/ui/components/widgets/default_app_bar.dart';
import 'package:notetakingapp1/features/note/ui/components/widgets/app_bar_with_folder_notes_ops.dart';
import 'package:notetakingapp1/features/note/ui/components/widgets/app_bar_with_folders_ops.dart';

class HomeAppbar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedNotesIsNotEmpty = ref.watch(
        selectedNotesControllerProvider(NoteType.allNotes)
            .select((notes) => notes.isNotEmpty));
    final selectedFoldersIsNotEmpty = ref.watch(
        selectedFoldersControllerProvider
            .select((folders) => folders.isNotEmpty));
    final selectedFolderNotesIsNotEmpty = ref.watch(
        selectedNotesControllerProvider(NoteType.folderNotes)
            .select((notes) => notes.isNotEmpty));

    return selectedNotesIsNotEmpty
        ? AppBarWithAllNotesOps()
        : selectedFoldersIsNotEmpty
            ? AppBarWithFolderOps()
            : selectedFolderNotesIsNotEmpty
                ? AppBarWithFolderNotesOps()
                : DefaultAppBar();
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
