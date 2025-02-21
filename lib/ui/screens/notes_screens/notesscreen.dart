import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:notetakingapp1/ui/utils/utils.dart';
import 'package:notetakingapp1/ui/widgets/note_card.dart';
import '/ui/utils/styles.dart';
import '/providers/auth_screen_providers/auth_state_provider.dart';
import '/providers/initial_location_provider.dart';
import '/ui/utils/confirmaton_dialog.dart';
import '/providers/notes_screen_providers.dart';

class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Formatted date
    final String formattedDate =
        DateFormat('d MMMM, yyyy').format(DateTime.now());

    //Access to notes provider
    final notesAsync = ref.watch(notesProvider);

    //List of selected notes
    final selectedNotes = ref.watch(selectionProvider);

    //Access to methods to manipulate selected notes list
    final selectionNotifier = ref.read(selectionProvider.notifier);

    //Access to authentication state and notifier
    final authState = ref.watch(authStateProvider);
    final authNotifier = ref.read(authStateProvider.notifier);

    //Displays authentication error messages if any
    if (authState.generalError != null || authState.isLoading) {
      showSnackbarMessage(context,
          message: authState.generalError ?? 'Logging out...');
    }

    //Navigates to login screen if logout is succesful
    ref.listen(authStateProvider, (previous, next) {
      if (next.successMessage == 'Log out is successful') {
        authNotifier.clearState(); //Clears all error messages
        ref.read(initialLocationProvider.notifier).setInitialLocation(
            '/login'); //Sets the login screen as the initial screen
        context.go('/login');
      }
    });

    //UI
    return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: selectedNotes.isNotEmpty
            ?
            //App bar when notes are selected
            AppBar(
                backgroundColor: colorScheme.surfaceContainerLowest,
                title: TextButton.icon(
                  onPressed: () {
                    selectionNotifier.clearSelection();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: colorScheme.primary,
                  ),
                  label: Text('${selectedNotes.length} selected',
                      style: Styles.textButtonStyle(fontSize: 18.0)),
                ))
            :
            //Normal app bar
            AppBar(
                elevation: 0.0,
                backgroundColor: colorScheme.surface,
                title: Padding(
                  padding: EdgeInsets.only(left: 6.0, right: 6.0, top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Date and Title
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formattedDate,
                            style: Styles.w400texts(
                              fontSize: 12.0,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            'Notes',
                            style: Styles.titleStyle(fontSize: 24.0),
                          ),
                        ],
                      ),

                      //Log out button
                      IconButton(
                        tooltip: 'Log Out',
                        onPressed: () async {
                          bool? confirmation = await showConfirmationDialog(
                              context,
                              type: 'Log out');
                          if (confirmation == true) {
                            await authNotifier.logOut();
                          }
                        },
                        icon: Icon(
                          Icons.logout,
                        ),
                        color: colorScheme.onSurface.withAlpha(153),
                      ),
                    ],
                  ),
                ),
              ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
                left: 18.0, right: 18.0, top: 10.0, bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: notesAsync.when(
                      //When notes are avaliable
                      data: (notes) {
                        //If notes are empty
                        if (notes.isEmpty) {
                          return Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.edit_note,
                                size: 50.0,
                              ),
                              const SizedBox(
                                height: 4.0,
                              ),
                              Text('No notes yet!\nCreate one.',
                                  textAlign: TextAlign.center,
                                  style: Styles.universalFont(fontSize: 20.0)),
                            ],
                          ));
                        }
                        //Display notes
                        return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 6.0,
                              mainAxisSpacing: 6.0,
                              childAspectRatio: 168 / 198,
                            ),
                            itemCount: notes.length,
                            itemBuilder: (context, index) {
                              final note = notes[index];
                              //Note Card
                              return NoteCard(note: note);
                            });
                      },
                      //When notes are loading
                      loading: () => Center(
                              child: CircularProgressIndicator(
                            color: colorScheme.primary,
                          )),

                      //When there is error
                      error: (error, stackTrace) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 10),
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('An error occured',
                                      style:
                                          Styles.universalFont(fontSize: 16.0)),
                                  TextButton(
                                      onPressed: () =>
                                          ref.refresh(notesProvider),
                                      child: Text(
                                        'Retry',
                                        style: Styles.textButtonStyle(
                                            fontSize: 16.0),
                                      ))
                                ],
                              )));
                        });
                        return SizedBox.shrink();
                      }),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 12.0, right: 6.0),
          child: selectedNotes.isNotEmpty
              ?
              //Delete note button
              FloatingActionButton(
                  tooltip: 'Delete note',
                  onPressed: () async {
                    String type = selectedNotes.length > 1
                        ? 'Delete notes'
                        : 'Delete note';
                    bool? confirmed =
                        await showConfirmationDialog(context, type: type);
                    if (confirmed == true) {
                      await ref
                          .read(deleteNoteProvider.notifier)
                          .deleteNote(selectedNotes);
                      selectionNotifier.clearSelection();
                    }
                  },
                  elevation: 2.0,
                  backgroundColor: colorScheme.error,
                  child: ref.watch(deleteNoteProvider).isLoading
                      ? SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(
                            color: colorScheme.onError,
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(
                          Icons.delete,
                          color: colorScheme.onError,
                        ),
                )
              :
              //Create note button
              FloatingActionButton(
                  tooltip: 'Create a new note',
                  onPressed: () {
                    context.go('/note');
                  },
                  elevation: 2.0,
                  backgroundColor: colorScheme.primary,
                  child: Icon(Icons.edit, color: colorScheme.onPrimary),
                ),
        ));
  }
}
