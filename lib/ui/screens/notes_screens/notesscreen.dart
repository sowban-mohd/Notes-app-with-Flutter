import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notetakingapp1/providers/auth_screen_providers/auth_state_provider.dart';
import 'package:notetakingapp1/providers/initial_location_provider.dart';
import 'package:notetakingapp1/providers/notes_screen_providers.dart';
import 'package:notetakingapp1/ui/utils/styles.dart';
import 'package:notetakingapp1/ui/utils/utils.dart';
import 'package:notetakingapp1/ui/widgets/note_screen_widgets.dart';

class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Providers access
    final selectedNotes = ref.watch(selectionProvider); //List of selected notes
    final authState = ref.watch(authStateProvider); //Authentication state
    final authNotifier = ref.read(authStateProvider
        .notifier); //Methods to manipukate authentication state

    //Displays authentication error messages if any
    if (authState.generalError != null || authState.isLoading) {
      showSnackbarMessage(context,
          message: authState.generalError ?? 'Logging out...');
    }

    //Navigates to login screen if logout is succesful
    FirebaseAuth.instance.authStateChanges().listen((user) {
      // User is logged out
      if (user == null) {
        authNotifier.clearState(); // Clears all error messages
        ref.read(initialLocationProvider.notifier).setInitialLocation(
            '/login'); //Sets login screen as the initial screen
        if (context.mounted) context.go('/login');
      }
    });

    //UI
    return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: NoteAppBar(),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
                left: 18.0, right: 18.0, top: 10.0, bottom: 16.0),
            child: Column(
              children: [
                if (selectedNotes.isEmpty) ...[
                  //Search bar
                  Padding(
                    padding: EdgeInsets.only(
                        top: 8.0, bottom: isDesktop(context) ? 18.0 : 10.0),
                    child: SearchBarWidget(),
                  ),
                ], //Search bar is hidden when note selection is on
                //Notes grid
                Expanded(child: NoteGrid()),
              ],
            ),
          ),
        ),
        floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 12.0, right: 6.0),
            child: NoteFloatingButton()));
  }
}
