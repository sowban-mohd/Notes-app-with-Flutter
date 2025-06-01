import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/core/constants/notetype.dart';
import 'package:notetakingapp1/core/utils.dart';
import 'package:notetakingapp1/features/notes/controller/folders_controller.dart';
import 'package:notetakingapp1/features/notes/controller/search_provider.dart';
import 'package:notetakingapp1/features/notes/models/folder.dart';
import 'package:notetakingapp1/features/notes/models/note.dart';
import 'package:notetakingapp1/features/notes/ui/components/layouts/notes_grid_view.dart';
import 'package:notetakingapp1/core/theme/styles.dart';
import 'package:notetakingapp1/features/notes/ui/components/widgets/empty_screen_body.dart';
import 'package:notetakingapp1/features/notes/ui/components/widgets/loader.dart';

class FolderNotesBody extends ConsumerWidget {
  final Folder folder;
  const FolderNotesBody({super.key, required this.folder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final folderName = folder.name;

    final foldersController = ref.read(foldersControllerProvider.notifier);

    if (folder.noteRefs.isEmpty) {
      return EmptyScreenBody(
          icon: Icons.edit_note_sharp,
          message: '$folderName is empty!\nCreate a note.');
    }

    return FutureBuilder<List<Note>>(
      future: foldersController.getFolderNotes(folder.noteRefs),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loader(color: colorScheme.secondary);
        } else if (snapshot.hasError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: Duration(seconds: 5),
                content: Text(
                  'Error : ${snapshot.error}',
                  style: Styles.universalFont(fontSize: 16.0),
                ),
              ),
            );
          });
          return SizedBox.shrink();
        } else if (snapshot.hasData) {
          final notes = snapshot.data!;
          final query = ref.watch(searchProvider);
          final isSearching = query.isNotEmpty;
          final filteredNotes =
              isSearching ? Utils.filterNotes(notes, query) : notes;

          if (filteredNotes.isEmpty) {
            return EmptyScreenBody(
                icon: Icons.search_off, message: 'No results!');
          }

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
                NotesGridView(
                  notes: notes,
                  noteType: NoteType.folderNotes,
                  folder: folder,
                ),
              ],
            ),
          );
        } else {
          return SizedBox.shrink(); // fallback
        }
      },
    );
  }
}
