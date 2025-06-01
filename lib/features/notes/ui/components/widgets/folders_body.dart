import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/features/notes/controller/folders_controller.dart';
import 'package:notetakingapp1/features/notes/controller/search_provider.dart';
import 'package:notetakingapp1/core/theme/styles.dart';
import 'package:notetakingapp1/features/notes/controller/selected_folders_controller.dart';
import 'package:notetakingapp1/core/utils.dart';
import 'package:notetakingapp1/features/notes/ui/components/widgets/empty_screen_body.dart';
import 'package:notetakingapp1/features/notes/ui/components/widgets/folder_notes_body.dart';

class FoldersBody extends ConsumerWidget {
  const FoldersBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersStream = ref.watch(folderStreamProvider);
    final query = ref.watch(searchProvider).toLowerCase().trim();

    ref.listen(folderStreamProvider, (_, next){
      next.whenData((folders) => ref.read(foldersListProvider.notifier).state = folders);
    });

    return foldersStream.when(data: (folders) {
      final isSearching = query.isNotEmpty;
      final currentlyClickedFolder = ref.watch(currentlyClickedFolderProvider);
      final currentlyClickedFolderController = ref.read(currentlyClickedFolderProvider.notifier);
      final filteredFolders = isSearching
          ? folders
              .where((folder) =>
                  (folder.name).toString().toLowerCase().contains(query))
              .toList()
          : folders;

      if (filteredFolders.isEmpty) {
        final icon = isSearching ? Icons.search_off : Icons.folder_outlined;
        final message =
            isSearching ? 'No results!' : 'No folders yet!\nCreate one.';
        return EmptyScreenBody(icon: icon, message: message);
      }

      if (currentlyClickedFolder == null) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 12.0, left: 16.0, bottom: 8.0),
              child: Text(
                'Folders',
                style: Styles.noteSectionTitle(),
              ),
            ),
            SizedBox(height: 6),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Utils.isDesktop(context)
                      ? 6
                      : Utils.isTablet(context)
                          ? 4
                          : 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 150 / 100,
                ),
                itemCount: filteredFolders.length,
                itemBuilder: (context, index) {
                  final folder = filteredFolders[index];
                  final folderName = folder.name;
                  final numberOfNotes = folder.noteRefs.length;
                  final isOnlyOneNote = numberOfNotes == 1;
                  final isThereMultipleNotes = numberOfNotes > 1;

                  return Consumer(builder: (context, ref, child) {
                    final selectedFolders =
                        ref.watch(selectedFoldersControllerProvider);
                    final bool isFolderSelected =
                        selectedFolders.contains(folder.id);
                    final folderSelectionController =
                        ref.read(selectedFoldersControllerProvider.notifier);
                    return GestureDetector(
                      onTap: () {
                        currentlyClickedFolderController.state = folder.id;
                        //ref.read(categoryProvider.notifier).state = folderName;
                      },
                      onLongPress: () {
                        folderSelectionController.toggleSelection(folder.id!);
                      },
                      child: Card(
                        color: Color(0xFFf4e8c2),
                        elevation: isFolderSelected ? 3.0 : 1.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: isFolderSelected
                              ? BorderSide(color: Color(0xFFA67B5B), width: 2.0)
                              : BorderSide.none,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.folder,
                                  size: 24.0, color: Color(0xFFA67B5B)),
                              const SizedBox(height: 8.0),
                              Text(
                                folderName,
                                textAlign: TextAlign.center,
                                style: Styles.w600texts(fontSize: 12.0),
                              ),
                              Text(
                                isThereMultipleNotes
                                    ? '$numberOfNotes items'
                                    : isOnlyOneNote
                                        ? '1 item'
                                        : 'Empty folder',
                                style: Styles.w400texts(fontSize: 10),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
          ],
        );
      } else {
        return FolderNotesBody(
            folder: folders.firstWhere((folder) => currentlyClickedFolder == folder.id));
      }
    }, error: (error, stacktrace) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(days: 1),
            content: Text('Error : ${error.toString()}',
                style: Styles.universalFont(fontSize: 16.0))));
      });

      return SizedBox.shrink();
    }, loading: () {
      return Center(
        child: CircularProgressIndicator(color: colorScheme.secondary),
      );
    });
  }
}
