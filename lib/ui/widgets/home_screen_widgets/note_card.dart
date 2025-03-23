import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notetakingapp1/logic/providers/home_screen_providers/category_provider.dart';
import 'package:notetakingapp1/logic/providers/home_screen_providers/pinned_selection_provider.dart';
import '../../../logic/providers/home_screen_providers.dart';
import '../../theme/styles.dart';

class NoteCard extends ConsumerWidget {
  final Map<String, dynamic> note;
  final bool isNotePinned;
  const NoteCard({super.key, required this.note, required this.isNotePinned});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedNotes = ref.watch(selectionProvider);
    final selectionNotifier = ref.read(selectionProvider.notifier);
    final selectedPinnedNotifier = ref.read(pinnedSelectionProvider.notifier);

    final category = ref.watch(categoryProvider);
    //Essential values
    final String noteId = note['noteId'];
    final String title = note['title'];
    final String content = note['content'];
    final bool hasTitle = title.trim().isNotEmpty;
    final bool hasContent = content.trim().isNotEmpty;

    return GestureDetector(
      //When tapped
      onTap: () {
        context.go('/note?noteId=$noteId');
      },
      //When long pressed
      onLongPress: () {
        if (isNotePinned) {
          selectedPinnedNotifier.toggleSelection(noteId);
        }
        selectionNotifier.toggleSelection(noteId);
      },
      child: Card(
        elevation: selectedNotes.contains(noteId) ? 3.0 : 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: selectedNotes.contains(noteId)
              ? BorderSide(
                  color: category == 'All Notes'
                      ? colorScheme.tertiary
                      : category == 'Folders'
                          ? colorScheme.secondary
                          : colorScheme.primary,
                  width: 2.0)
              : BorderSide.none,
        ),
        color: category == 'All Notes'
            ? Color(0xFFe8e8ed)
            : category == 'Folders'
                ? Color(0xFFf4e8c2)
                : colorScheme.surfaceContainer,
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
                              color: colorScheme.onSurface, fontSize: 14),
                          overflow: TextOverflow.fade),
                    )
                  : Text(
                      'No content',
                      style: Styles.w300texts(
                          color: colorScheme.onSurface.withAlpha(102),
                          fontSize: 14),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
