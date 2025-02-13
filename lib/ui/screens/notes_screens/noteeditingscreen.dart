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
    final titleController = ref.watch(notesControllersProvider).titleController;
    final contentController =
        ref.watch(notesControllersProvider).contentController;
    final noteSaveState = ref.watch(saveNoteProvider);
    final noteSaveNotifier = ref.read(saveNoteProvider.notifier);
    final isLoading = noteSaveState.isLoading;
    final noteId = GoRouterState.of(context).uri.queryParameters['noteId'];

    if (noteSaveState.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(noteSaveState.error!)));
      });
    }

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
                    ElevatedButton(
                        onPressed: () async {
                          await noteSaveNotifier.saveNote(
                              titleController.text, contentController.text,
                              noteId: noteId);
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            minimumSize: const Size(60, 35),
                            backgroundColor: Color.fromRGBO(31, 33, 36, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                        child: isLoading
                            ? SizedBox(
                                width: 15,
                                height: 15,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Save',
                                style: GoogleFonts.nunitoSans(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ))
                  ]),
            ),
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
                  fontSize: 26.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    hintText: 'Page Title',
                    hintStyle: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 26.0,
                      color: Color.fromRGBO(28, 33, 33, 0.3),
                    )),
              ),
            ),
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
                          left: 20.0, right: 20.0, top: 12.0, bottom: 20.0),
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
