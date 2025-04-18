import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/logic/providers/category_provider.dart';
import 'package:notetakingapp1/logic/providers/folder_notes_selection_provider.dart';
import 'package:notetakingapp1/logic/providers/body_stream_provider.dart';
import 'package:notetakingapp1/logic/providers/search_provider.dart';
import 'package:notetakingapp1/logic/utils/utils.dart';
import 'package:notetakingapp1/ui/screens/main_screens/folder_note_editing_screen.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';

class FolderNotesBody extends ConsumerWidget {
  const FolderNotesBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesStream = ref.watch(bodyStreamProvider);
    return notesStream.when(data: (notes) {
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
            Consumer(
              builder: (context, ref, child) {
                final folderName = ref.watch(categoryProvider);
                return Text('$folderName is empty!\nCreate a note.',
                  textAlign: TextAlign.center,
                  style: Styles.universalFont(fontSize: 20.0));
              }
            ),
          ],
        ));
      }

      final folderName = ref.watch(categoryProvider);
      final query = ref.watch(searchProvider);
      final filteredNotes = filterNotes(notes, query);
      final selectedNotes = ref.watch(folderNoteSelectionProvider);
      final selectionNotifier = ref.read(folderNoteSelectionProvider.notifier);

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 12.0, left: 16.0, bottom: 8.0),
              child: Text(
                folderName,
                style: Styles.noteSectionTitle(),
              ),
            ),
            GridView.builder(
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
                  final note = filteredNotes[index];
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
                              builder: (context) =>
                                  FolderNoteEditingScreen(note: note)));
                    },
                    //When long pressed
                    onLongPress: () {
                      selectionNotifier.toggleSelection(noteId);
                    },
                    child: Card(
                      elevation: selectedNotes.contains(noteId) ? 3.0 : 1.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: selectedNotes.contains(noteId)
                            ? BorderSide(color: Color(0xFFA67B5B), width: 2.0)
                            : BorderSide.none,
                      ),
                      color: const Color(0xFFf4e8c2),
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
                                  fontSize: 16,
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
                                            color: colorScheme.onSurface,
                                            fontSize: 14),
                                        overflow: TextOverflow.fade),
                                  )
                                : Text(
                                    'No content',
                                    style: Styles.w300texts(
                                        color: colorScheme.onSurface
                                            .withAlpha(102),
                                        fontSize: 14),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ],
        ),
      );
    }, error: (error, stacktrace) {
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
                  ref.refresh(bodyStreamProvider);
                },
                child: Text(
                  'Retry',
                  style: Styles.textButtonStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ));
      });
      return SizedBox.shrink();
    }, loading: () {
      return Center(
        child: CircularProgressIndicator(color: colorScheme.secondary),
      );
    });
  }
}
