import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/providers/notes_screen_providers.dart';
import 'package:notetakingapp1/ui/utils/styles.dart';
import 'package:notetakingapp1/ui/utils/utils.dart';
import 'package:notetakingapp1/ui/widgets/note_screen_widgets/note_card.dart';

class NoteGrid extends ConsumerWidget {
  const NoteGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesProvider); //Access to notes provider
    final searchQuery = ref.watch(searchProvider); //Access to search query
    return notesAsync.when(
        //When notes are avaliable
        data: (allNotes) {
          //If notes are empty
          if (allNotes.isEmpty) {
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
                Text('No notes yet!\nCreate one.',
                    textAlign: TextAlign.center,
                    style: Styles.universalFont(fontSize: 20.0)),
              ],
            ));
          }

          //If notes are not empty
          //filtering notes based on search query
          final filteredNotes = searchQuery.isEmpty
              ? allNotes
              : allNotes.where((note) {
                  return note['title']
                          .toString()
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()) ||
                      note['content']
                          .toString()
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase());
                }).toList();
          //Notes grid
          return GridView.builder(
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
              itemCount: filteredNotes.length,
              itemBuilder: (context, index) {
                final note = filteredNotes[index];
                //Note Card
                return NoteCard(note: note);
              });
        },
        //When notes are loading
        loading: () => Center(
                child: CircularProgressIndicator(
              color: colorScheme.primary,
            )),

        //When there is error
        error: (error, stackTrace) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: Duration(seconds: 5),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('An error occured',
                        style: Styles.universalFont(fontSize: 16.0)),
                    TextButton(
                        onPressed: () => ref.refresh(notesProvider),
                        child: Text(
                          'Retry',
                          style: Styles.textButtonStyle(fontSize: 16.0),
                        ))
                  ],
                )));
          });
          return SizedBox.shrink();
        });
  }
}
