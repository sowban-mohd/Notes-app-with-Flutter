import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/core/constants/notetype.dart';
import 'package:notetakingapp1/features/note/controller/selected_notes_controller.dart';
import 'package:notetakingapp1/features/note/models/folder.dart';
import 'package:notetakingapp1/features/note/models/note.dart';
import 'package:notetakingapp1/features/note/ui/screens/folder_note_editing_screen.dart';
import 'package:notetakingapp1/features/note/ui/screens/note_editing_screen.dart';
import 'package:notetakingapp1/core/theme/styles.dart';
import 'package:notetakingapp1/core/utils.dart';

class NotesGridView extends ConsumerWidget {
  final List<Note> notes;
  final NoteType noteType;
  final Folder? folder;
  const NotesGridView(
      {super.key, required this.notes, required this.noteType, this.folder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPinnedNotes = noteType == NoteType.pinnedNotes;
    final isFolderNotes = noteType == NoteType.folderNotes;
    final noteSelectionProvider = isPinnedNotes
        ? selectedNotesControllerProvider(NoteType.allNotes)
        : selectedNotesControllerProvider(noteType);
    final selectedNotes = ref.watch(noteSelectionProvider);
    final selectionController = ref.read(noteSelectionProvider.notifier);

    //Notes grid
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: Utils.isDesktop(context)
              ? 6
              : Utils.isTablet(context)
                  ? 4
                  : 2,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
          childAspectRatio: 168 / 198,
        ),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          final noteId = note.id;
          final String title = note.title;
          final String content = note.content;
          final bool hasTitle = title.trim().isNotEmpty;
          final bool hasContent = content.trim().isNotEmpty;
          //Note Card
          return GestureDetector(
            //When tapped
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return isFolderNotes
                    ? FolderNoteEditingScreen(
                        note: note,
                      )
                    : NoteEditingscreen(
                        note: note,
                      );
              }));
            },
            //When long pressed
            onLongPress: () {
              if (isPinnedNotes) {
                ref
                    .read(selectedNotesControllerProvider(NoteType.pinnedNotes)
                        .notifier)
                    .toggleSelection(noteId!);
              }
              selectionController.toggleSelection(noteId!);
            },
            child: Card(
              elevation: selectedNotes.contains(noteId) ? 3.0 : 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: selectedNotes.contains(noteId)
                    ? BorderSide(
                        color: isFolderNotes
                            ? Color(0xFFA67B5B)
                            : Color(0xFF4E94F8),
                        width: 2.0)
                    : BorderSide.none,
              ),
              color: isFolderNotes ? Color(0xFFf4e8c2) : Color(0xFFDCEBFE),
              child: Padding(
                padding: EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasTitle) ...[
                      Text(
                        title,
                        style: Styles.w600texts(
                          color: colorScheme.onSurface,
                          fontSize: 14,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 3),
                      Divider(),
                      SizedBox(
                        height: 3,
                      ),
                    ],
                    hasContent
                        ? Flexible(
                            child: Text(content,
                                style: Styles.w300texts(
                                    color: colorScheme.onSurface, fontSize: 12),
                                overflow: TextOverflow.fade),
                          )
                        : Text(
                            'No content',
                            style: Styles.w300texts(
                                color: colorScheme.onSurface.withAlpha(102),
                                fontSize: 12),
                          ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
