import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notetakingapp1/logic/providers/auth_change_provider.dart';
import 'package:notetakingapp1/logic/providers/auth_screen_providers/auth_state_provider.dart';
import 'package:notetakingapp1/logic/providers/home_screen_providers/category_provider.dart';
import 'package:notetakingapp1/logic/providers/home_screen_providers/folders_provider.dart';
import 'package:notetakingapp1/logic/providers/initial_location_provider.dart';
import 'package:notetakingapp1/logic/providers/home_screen_providers.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';
import 'package:notetakingapp1/logic/utils/utils.dart';
import 'package:notetakingapp1/ui/widgets/home_screen_widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialLocationNotifier = ref.read(initialLocationProvider.notifier);
    final authChange = ref.watch(authChangeProvider);

    // Navigate to login screen if the user is logged out
    authChange.whenData((user) async {
      if (user == null) {
        await initialLocationNotifier.setInitialLocation('/login');
        if (context.mounted) context.go('/login');
      }
    });

    //Displays authentication error messages if any
    ref.listen<AuthState>(authStateProvider, (previous, next) {
      if (next.generalError != null) {
        showSnackbarMessage(context, message: next.generalError!);
        ref.read(authStateProvider.notifier).clearState();
      }
    });

    // Display error message if there is an error in note cud operations
    ref.listen<String?>(noteCudProvider, (previous, next) {
      if (next != null) {
        showSnackbarMessage(context, message: next);
        ref.read(noteCudProvider.notifier).clearError();
      }
    });

    //UI
    return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: NoteAppBar(),
        body: SafeArea(
          // Main body of the screen
          child: Padding(
            padding: EdgeInsets.only(
                left: 18.0, right: 18.0, top: 10.0, bottom: 16.0),
            child: Consumer(builder: (context, ref, child) {
              final notes = ref.watch(notesProvider);
              final notesNotifier = ref.read(notesProvider.notifier);
              final folders = ref.watch(foldersProvider);
              final foldersNotifier = ref.read(foldersProvider.notifier);
              final category = ref.watch(categoryProvider);

              //When notes/folders are loading
              if (notesNotifier.isLoading || foldersNotifier.isLoading) {
                return Center(
                    child: CircularProgressIndicator(
                  color: colorScheme.primary,
                ));
              }

              //Displays a snackbar if there is any error in loading notes
              if (notesNotifier.errorMessage != null ||
                  foldersNotifier.errorMessage != null) {
                debugPrint(
                    notesNotifier.errorMessage ?? foldersNotifier.errorMessage);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: Duration(days: 1),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('An error occured',
                              style: Styles.universalFont(fontSize: 16.0)),
                          TextButton(
                              onPressed: () {
                                if (notesNotifier.errorMessage != null) {
                                  notesNotifier.retry();
                                } else if (foldersNotifier.errorMessage !=
                                    null) {
                                  foldersNotifier.retry();
                                } else {
                                  notesNotifier.retry();
                                  foldersNotifier.retry();
                                }
                              },
                              child: Text(
                                'Retry',
                                style: Styles.textButtonStyle(fontSize: 16.0),
                              ))
                        ],
                      )));
                  notesNotifier.clearError();
                });
                return SizedBox.shrink();
              }

              //When notes are empty
              if (notes.isEmpty) {
                return Expanded(
                    child:
                        EmptyNoteScreenBody()); // Screen to display if notes are empty
              }

              //When notes are not empty
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchBarWidget(), // A searchbar allowing user to filter notes
                  CategoryList(), //A list displays multiple categories (All Notes, Folders)
                  Expanded(
                      child: category == 'All Notes'
                          ? AllNotesBody(notes: notes)
                          : FoldersBody(folders: folders)),
                ],
              );
            }),
          ),
        ),
        floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 12.0, right: 6.0),
            child: NoteFloatingButton()));
  }
}
