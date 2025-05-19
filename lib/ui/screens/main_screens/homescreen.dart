import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notetakingapp1/logic/providers/auth_screen/auth_state_provider.dart';
import 'package:notetakingapp1/logic/providers/home_screen/category_provider.dart';
import 'package:notetakingapp1/logic/providers/folder_notes_category/folder_notes_selection_provider.dart';
import 'package:notetakingapp1/logic/providers/folders_category/folder_selection_provider.dart';
import 'package:notetakingapp1/logic/providers/all_notes_category/note_ops_state_provider.dart';
import 'package:notetakingapp1/logic/providers/all_notes_category/note_selection_provider.dart';
import 'package:notetakingapp1/logic/providers/initial_location_provider.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';
import 'package:notetakingapp1/ui/widgets/all_notes_category/all_notes_body.dart';
import 'package:notetakingapp1/ui/widgets/all_notes_category/app_bar_with_all_notes_ops.dart';
import 'package:notetakingapp1/ui/widgets/folder_notes_category/app_bar_with_folder_notes_ops.dart';
import 'package:notetakingapp1/ui/widgets/folders_category/app_bar_with_folders_ops.dart';
import 'package:notetakingapp1/ui/widgets/category_list.dart';
import 'package:notetakingapp1/ui/widgets/default_app_bar.dart';
import 'package:notetakingapp1/ui/widgets/folder_notes_category/folder_notes_body.dart';
import 'package:notetakingapp1/ui/widgets/folders_category/folders_body.dart';
import 'package:notetakingapp1/ui/widgets/home_fab.dart';
import 'package:notetakingapp1/ui/widgets/search_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
   final screenWidth = MediaQuery.sizeOf(context).width;
   final screenHeight = MediaQuery.sizeOf(context).height;

    // Listener for generalError
    ref.listen(authStateProvider.select((state) => state.generalError),
        (prev, next) async {
      if (next != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next)),
          );
        });
      }
    });

    ref.listen(authStateProvider.select((state) => state.user),
        (prev, next) async {
      if (next == null) {
        final initialLocationNotifier =
            ref.read(initialLocationProvider.notifier);
        await initialLocationNotifier.setInitialLocation('/welcome');
        await Future.delayed(Duration(seconds: 1));
        if (context.mounted) context.go('/welcome');
      }
    });

    // Listener for note operation errors
    ref.listen<String?>(noteOpsStateProvider, (previous, next) {
      if (next != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next)),
          );
        });
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
            child: Consumer(
              builder: (context, ref, child) {
                final user =
                    ref.watch(authStateProvider.select((state) => state.user));
                if (user == null) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: colorScheme.primary,
                      ),
                      Text(
                        'Logging out...',
                        style: Styles.universalFont(fontSize: 16.0),
                      ),
                    ],
                  )); // Show spinner
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SearchBarWidget(),
                    CategoryList(),
                    SizedBox(height: screenHeight * 0.01),
                    Expanded(
                      child: category == 'All Notes'
                          ? AllNotesBody()
                          : category == 'Folders'
                              ? FoldersBody()
                              : FolderNotesBody(),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        floatingActionButton: HomeFAB());
  }
}
