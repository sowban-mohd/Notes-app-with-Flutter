import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notetakingapp1/logic/providers/auth_change_provider.dart';
import 'package:notetakingapp1/logic/providers/auth_screen_providers/auth_state_provider.dart';
import 'package:notetakingapp1/logic/providers/home_screen_providers/category_provider.dart';
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

    // Display error messsage if there is any error in deleting note
    ref.listen<String?>(deleteNoteProvider, (previous, next) {
      if (next != null) {
        showSnackbarMessage(context, message: next);
        ref.read(deleteNoteProvider.notifier).clearError();
      }
    });

    // Display error message if there is an error in saving note
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
              final notesNotifier = ref.watch(notesProvider.notifier);
              final query = ref.watch(searchProvider);
              final category = ref.watch(categoryProvider);

              if (notesNotifier.isLoading) {
                return Center(
                    child: CircularProgressIndicator(
                  color: colorScheme.primary,
                ));
              }

              if (notesNotifier.errorMessage != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: Duration(days: 1),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('An error occured',
                              style: Styles.universalFont(fontSize: 16.0)),
                          TextButton(
                              onPressed: () => notesNotifier.retry(),
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

              if (notes.isEmpty) {
                return EmptyNoteScreenBody(); // Screen to display if notes are empty
              }

              final pinnedNotes =
                  notes.where((note) => note['pinned'] == true).toList();
              final otherNotes =
                  notes.where((note) => note['pinned'] == false).toList();
              final filteredPinnedNotes = filterNotes(pinnedNotes, query);
              final filteredOtherNotes = filterNotes(otherNotes, query);

              // If notes are not empty
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchBarWidget(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CategoryGrid(),
                          if (filteredPinnedNotes.isNotEmpty) ...[
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 12.0, left: 16.0, bottom: 8.0),
                              child: Text(
                                'Pinned Notes',
                                style: Styles.noteSectionTitle(),
                              ),
                            ),
                            NotesGridView(
                                notes: filteredPinnedNotes, isNotePinned: true),
                            if (filteredOtherNotes.isNotEmpty) ...[
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 12.0, left: 16.0, bottom: 8.0),
                                child: Text(
                                  'Other Notes',
                                  style: Styles.noteSectionTitle(),
                                ),
                              ),
                            ]
                          ],
                          if (filteredPinnedNotes.isEmpty) ...[
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 12.0, left: 16.0, bottom: 8.0),
                              child: Text(
                                category,
                                style: Styles.noteSectionTitle(),
                              ),
                            ),
                          ],
                          NotesGridView(
                              notes: filteredOtherNotes, isNotePinned: false),
                        ],
                      ),
                    ),
                  ),
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
