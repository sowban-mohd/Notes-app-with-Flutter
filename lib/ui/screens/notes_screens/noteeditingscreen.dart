import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/notes_screen_providers/note_controllers.dart';
import '../../../providers/notes_screen_providers/save_note_provider.dart';

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

    //Note Id from url
    final noteId = GoRouterState.of(context).uri.queryParameters['noteId'];

    //Display error messages if any
    if (noteSaveState.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(noteSaveState.error!)));
      });
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Back button and Save button on top
            Padding(
              padding: const EdgeInsets.only(
                  left: 2.0, right: 10.0, top: 6.0, bottom: 24.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        noteSaveNotifier.clearState();
                        ref.invalidate(notesControllersProvider);
                        context.go('/home');
                      },
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.blue),
                      label: Text(
                        "Back",
                        style: GoogleFonts.nunitoSans(
                          color: Colors.blue,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () async {
                          await noteSaveNotifier.saveNote(
                              titleController.text, contentController.text,
                              noteId: noteId);
                        },
                        child: noteSaveState.isLoading
                            ? SizedBox(
                                width: 15,
                                height: 15,
                                child: CircularProgressIndicator(
                                  color: Colors.blue,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Save',
                                style: GoogleFonts.nunitoSans(
                                  color: Colors.blue,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ))
                  ]),
            ),

            //Title Field
            Theme(
              data: ThemeData(
                textSelectionTheme: TextSelectionThemeData(
                  cursorColor: Colors.blue,
                  selectionColor: Colors.blue.withAlpha(51),
                  selectionHandleColor: Colors.blue,
                ),
              ),
              child: TextField(
                controller: titleController,
                style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 24.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
                    hintText: 'Page Title',
                    hintStyle: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0,
                      color: Color.fromRGBO(28, 33, 33, 0.3),
                    )),
              ),
            ),

            //Content field
            Expanded(
              child: Theme(
                data: ThemeData(
                  textSelectionTheme: TextSelectionThemeData(
                    cursorColor: Colors.blue,
                    selectionColor: Colors.blue.withAlpha(51),
                    selectionHandleColor: Colors.blue,
                  ),
                ),
                child: TextField(
                  controller: contentController,
                  style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.normal,
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 22.0, right: 22.0, top: 12.0, bottom: 20.0),
                      hintText: 'Notes goes here...',
                      hintStyle: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.normal,
                        fontSize: 16.0,
                        color: Color.fromRGBO(28, 33, 33, 0.3),
                      )),
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
