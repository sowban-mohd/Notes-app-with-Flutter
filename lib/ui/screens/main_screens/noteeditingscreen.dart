import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/logic/providers/home_screen_providers/notes_provider.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';
import '../../../logic/providers/home_screen_providers/note_cud_state_provider.dart';

class NoteEditingscreen extends StatefulWidget {
  const NoteEditingscreen({super.key});

  @override
  State<NoteEditingscreen> createState() => _NoteEditingscreenState();
}

class _NoteEditingscreenState extends State<NoteEditingscreen> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  String? noteId;
  bool? pinned;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    contentController = TextEditingController();
  }

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final params = GoRouterState.of(context).uri.queryParameters;
      noteId = params['noteId'];
      if (noteId != null) {
        final notes = ProviderScope.containerOf(context).read(notesProvider);
        final note = notes.firstWhere((note) => note['noteId'] == noteId);
        titleController.text = note['title'];
        contentController.text = note['content'];
        pinned = note['pinned'];
      }
      _initialized = true;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final saveNoteNotifier = ProviderScope.containerOf(context).read(noteCudProvider.notifier);

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 2.0, right: 10.0, top: 8.0, bottom: 24.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Back button
                    TextButton.icon(
                      onPressed: () {
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
                    //Save button
                    TextButton(
                        onPressed: () async {
                          await saveNoteNotifier.saveNote(
                              title : titleController.text, content : contentController.text,
                              noteId: noteId, pinned : pinned);
                          if (context.mounted) context.go('/home');
                        },
                        child: Text(
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
