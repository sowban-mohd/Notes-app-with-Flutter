import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/ui/utils/styles.dart';
import 'package:notetakingapp1/ui/utils/utils.dart';
import '../../../providers/notes_screen_providers/note_controllers_provider.dart';
import '/providers/notes_screen_providers/save_note_provider.dart';

class NoteEditingscreen extends ConsumerWidget {
  const NoteEditingscreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Controllers
    final titleController = ref.watch(notesControllersProvider).titleController;
    final contentController =
        ref.watch(notesControllersProvider).contentController;

    //Note saving state and notifier
    final noteSaveState = ref.watch(saveNoteProvider);
    final noteSaveNotifier = ref.read(saveNoteProvider.notifier);

    //Display error messages if any
    if (noteSaveState.error != null) {
      showSnackbarMessage(context, message: noteSaveState.error!);
    }

    //Navigates to notes screen if note saving is success
    ref.listen(saveNoteProvider, (previous, next) {
      if (next.success != null) {
        noteSaveNotifier.clearState();
        ref.invalidate(notesControllersProvider);
        context.go('/home');
      }
    });

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Back button and Save button on top
            Padding(
              padding: const EdgeInsets.only(
                  left: 2.0, right: 10.0, top: 8.0, bottom: 24.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        noteSaveNotifier.clearState();
                        ref.invalidate(notesControllersProvider);
                        context.go('/home');
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: colorScheme.primary,
                      ),
                      label: Text(
                        "Back",
                        style: Styles.textButtonStyle(fontSize: 16.0),
                      ),
                    ),
                    TextButton(
                        onPressed: () async {
                          //Note Id from url
                          final noteId = GoRouterState.of(context)
                              .uri
                              .queryParameters['noteId'];
                          await noteSaveNotifier.saveNote(
                              titleController.text, contentController.text,
                              noteId: noteId);
                        },
                        child: noteSaveState.isLoading
                            ? SizedBox(
                                width: 15,
                                height: 15,
                                child: CircularProgressIndicator(
                                  color: colorScheme.primary,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Save',
                                style: Styles.textButtonStyle(fontSize: 16.0),
                              ))
                  ]),
            ),
            //Title Field
            Theme(
              data: Styles.textSelectionTheme(),
              child: TextField(
                controller: titleController,
                style: Styles.titleStyle(
                    fontSize: 24.0, color: colorScheme.onSurface),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 22.0),
                    hintText: 'Page Title',
                    hintStyle: Styles.titleStyle(
                      fontSize: 24.0,
                      color: colorScheme.onSurface.withAlpha(66),
                    )),
              ),
            ),

            //Content field
            Expanded(
              child: Theme(
                data: Styles.textSelectionTheme(),
                child: TextField(
                  controller: contentController,
                  style: Styles.w400texts(
                      fontSize: 16.0, color: colorScheme.onSurface),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 24.0, right: 24.0, top: 12.0, bottom: 20.0),
                      hintText: 'Notes goes here...',
                      hintStyle: Styles.w400texts(
                          fontSize: 16.0,
                          color: colorScheme.onSurface.withAlpha(66))),
                  maxLines: null,
                  expands: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
