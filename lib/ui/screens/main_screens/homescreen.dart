import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notetakingapp1/logic/providers/auth_screen_providers/auth_state_provider.dart';
import 'package:notetakingapp1/logic/providers/folder_notes_selection_provider.dart';
import 'package:notetakingapp1/logic/providers/category_provider.dart';
import 'package:notetakingapp1/logic/providers/folders_providers.dart';
import 'package:notetakingapp1/logic/providers/initial_location_provider.dart';
import 'package:notetakingapp1/logic/providers/note_ops_state_provider.dart';
import 'package:notetakingapp1/logic/providers/note_selection_provider.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';
import 'package:notetakingapp1/ui/widgets/all_notes_body.dart';
import 'package:notetakingapp1/ui/widgets/app_bar_with_all_notes_ops.dart';
import 'package:notetakingapp1/ui/widgets/app_bar_with_folder_notes_ops.dart';
import 'package:notetakingapp1/ui/widgets/app_bar_with_folders_ops.dart';
import 'package:notetakingapp1/ui/widgets/category_list.dart';
import 'package:notetakingapp1/ui/widgets/default_app_bar.dart';
import 'package:notetakingapp1/ui/widgets/folder_notes_body.dart';
import 'package:notetakingapp1/ui/widgets/folders_body.dart';
import 'package:notetakingapp1/ui/widgets/home_fab.dart';
import 'package:notetakingapp1/ui/widgets/search_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listener for generalError
    ref.listen(authStateProvider.select((state) => state.generalError),
        (prev, next) async {
      if (next != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next)),
        );
      }
    });

    // Listener for user state
    ref.listen(authStateProvider.select((state) => state.user),
        (prev, next) async {
      if (next == null) {
        final initialLocationNotifier =
            ref.read(initialLocationProvider.notifier);
        await initialLocationNotifier.setInitialLocation('/login');
        if (context.mounted) context.go('/login');
      }
    });

    // Listener for note operation state
    ref.listen<String?>(noteOpsStateProvider, (previous, next) {
      if (next != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(next)));
      }
    });

    final category = ref.watch(categoryProvider);
    final selectedNotes = ref.watch(noteSelectionProvider(NoteType.all));
    final selectedFolders = ref.watch(folderSelectionProvider);
    final selectedFolderNotes = ref.watch(folderNoteSelectionProvider);

    return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: category == 'All Notes' && selectedNotes.isNotEmpty
            ? AppBarWithAllNotesOps()
            : category == 'Folders' && selectedFolders.isNotEmpty
                ? AppBarWithFolderOps()
                : selectedFolderNotes.isNotEmpty
                    ? AppBarWithFolderNotesOps()
                    : DefaultAppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 18.0, right: 18.0, top: 10.0, bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchBarWidget(),
                CategoryList(),
                Expanded(
                  child: category == 'All Notes'
                      ? AllNotesBody()
                      : category == 'Folders'
                          ? FoldersBody()
                          : FolderNotesBody(),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: HomeFAB());
  }
}
