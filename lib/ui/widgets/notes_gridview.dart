import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/logic/providers/all_notes_category/note_selection_provider.dart';
import 'package:notetakingapp1/logic/providers/all_notes_category/should_select_all_notes_provider.dart';
import 'package:notetakingapp1/logic/utils/utils.dart';
import 'package:notetakingapp1/ui/screens/main_screens/note_editing_screen.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';

class NotesGridView extends ConsumerWidget {
  final List<Map<String, dynamic>> notes;
  final bool isNotePinned;
  const NotesGridView(
      {super.key, required this.notes, required this.isNotePinned});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedNotes = ref.watch(noteSelectionProvider(NoteType.all));
    final selectionNotifier =
        ref.read(noteSelectionProvider(NoteType.all).notifier);

    ref.listen<bool>(shouldSelectAllNotesProvider, (previous, next) {
      if (next == true) {
        final allNoteIds =
            notes.map((note) => note['noteId'] as String).toSet();
        selectionNotifier.selectAll(allNoteIds);
        if (isNotePinned) {
          ref
              .read(noteSelectionProvider(NoteType.pinned).notifier)
              .selectAll(allNoteIds);
        }
      } else if (next == false) {
        selectionNotifier.clearSelection();
        if (isNotePinned) {
          ref
              .read(noteSelectionProvider(NoteType.pinned).notifier)
              .clearSelection();
        }
      }
    });

    //Notes grid
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isDesktop(context)
              ? 6
              : isTablet(context)
                  ? 4
                  : 2,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
          childAspectRatio: 168 / 198,
        ),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          final String noteId = note['noteId'];
          final String title = note['title'];
          final String content = note['content'];
          final bool hasTitle = title.trim().isNotEmpty;
          final bool hasContent = content.trim().isNotEmpty;
          //Note Card
          return GestureDetector(
            //When tapped
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NoteEditingscreen(note: note)));
            },
            //When long pressed
            onLongPress: () {
              selectionNotifier.toggleSelection(noteId);
              if (isNotePinned) {
                ref
                    .read(noteSelectionProvider(NoteType.pinned).notifier)
                    .toggleSelection(noteId);
              }
            },
            child: Card(
              elevation: selectedNotes.contains(noteId) ? 3.0 : 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: selectedNotes.contains(noteId)
                    ? BorderSide(color: Color(0xFF4E94F8), width: 2.0)
                    : BorderSide.none,
              ),
              color: Color(0xFFDCEBFE),
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
