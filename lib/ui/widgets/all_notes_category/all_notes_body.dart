import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/logic/providers/all_notes_category/all_notes_provider.dart';
import 'package:notetakingapp1/logic/providers/all_notes_category/notes_list_provider.dart';
import 'package:notetakingapp1/logic/providers/home_screen/search_provider.dart';
import 'package:notetakingapp1/logic/utils/utils.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';
import 'package:notetakingapp1/ui/widgets/notes_gridview.dart';

class AllNotesBody extends ConsumerWidget {
  const AllNotesBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
     ref.listen(allNotesProvider, (prev, next) {
      next.whenData(
          (notes) => ref.read(notesListProvider.notifier).state = notes);
    });

    final notesStream = ref.watch(allNotesProvider);
    return notesStream.when(
      data: (notes) {
        final query = ref.watch(searchProvider).trim();
        final isSearching = query.isNotEmpty;

        final pinnedNotes =
            notes.where((note) => note['pinned'] == true).toList();
        final otherNotes =
            notes.where((note) => note['pinned'] == false).toList();

        final filteredPinnedNotes =
            isSearching ? filterNotes(pinnedNotes, query) : pinnedNotes;
        final filteredOtherNotes =
            isSearching ? filterNotes(otherNotes, query) : otherNotes;

        if (filteredPinnedNotes.isEmpty &&
            filteredOtherNotes.isEmpty) {
         final message = isSearching
            ? 'No results!'
            : 'No notes yet!\nCreate one.';
        final icon = isSearching ? Icons.search_off : Icons.edit_note_sharp;

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50.0, color: Colors.grey),
              const SizedBox(height: 8.0),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Styles.universalFont(fontSize: 20.0),
              ),
            ],
          ),
        );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (filteredPinnedNotes.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.only(top: 12.0, left: 16.0, bottom: 8.0),
                  child: Text('Pinned Notes', style: Styles.noteSectionTitle()),
                ),
                NotesGridView(notes: filteredPinnedNotes, isNotePinned: true),
                if (filteredOtherNotes.isNotEmpty) ...[
                  Padding(
                    padding:
                        EdgeInsets.only(top: 12.0, left: 16.0, bottom: 8.0),
                    child:
                        Text('Other Notes', style: Styles.noteSectionTitle()),
                  ),
                ],
              ],
              if (filteredPinnedNotes.isEmpty) ...[
                Padding(
                  padding: EdgeInsets.only(top: 12.0, left: 16.0, bottom: 8.0),
                  child: Text('All Notes', style: Styles.noteSectionTitle()),
                ),
              ],
              NotesGridView(notes: filteredOtherNotes, isNotePinned: false),
            ],
          ),
        );
      },
      error: (error, stacktrace) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(days: 1),
              content: Text('Error : ${error.toString()}',
                  style: Styles.universalFont(fontSize: 16.0)),
            ),
          );
        });
        return SizedBox.shrink();
      },
      loading: () => Center(
        child: CircularProgressIndicator(color: colorScheme.primary),
      ),
    );
  }
}
