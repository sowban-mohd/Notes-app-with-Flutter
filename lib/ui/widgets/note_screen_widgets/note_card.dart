import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '/providers/notes_screen_providers.dart';
import '/ui/utils/styles.dart';

class NoteCard extends ConsumerWidget {
  final Map<String, dynamic> note;
  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //List of selected notes
    final selectedNotes = ref.watch(selectionProvider);
    //Essential values
    final String noteId = note['noteId'];
    final String title = note['title'];
    final String content = note['content'];
    final bool hasTitle = title.trim().isNotEmpty;
    final bool hasContent = content.trim().isNotEmpty;

    return GestureDetector(
      //When tapped
      onTap: () {
        final controllers = ref.watch(notesControllersProvider);
        controllers.titleController.text = note['title'];
        controllers.contentController.text = note['content'];
        context.go('/note?noteId=$noteId');
      },
      //When long pressed
      onLongPress: () {
        //Access to methods to manipulate selected notes list
        final selectionNotifier = ref.read(selectionProvider.notifier);
        selectionNotifier.toggleSelection(noteId);
      },
      child: Card(
        elevation: selectedNotes.contains(noteId) ? 3.0 : 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: selectedNotes.contains(noteId)
              ? BorderSide(color: colorScheme.primary, width: 2.0)
              : BorderSide.none,
        ),
        color: colorScheme.surfaceContainer,
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
              hasContent ?
              Flexible(
                child: Text(content,
                    style: Styles.w300texts(
                        color: colorScheme.onSurface, fontSize: 14),
                    overflow: TextOverflow.fade),
              ) :
              Text('No content',
                    style: Styles.w300texts(
                        color: colorScheme.onSurface.withAlpha(102), fontSize: 14),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
