import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/logic/providers/home_screen/category_provider.dart';
import 'package:notetakingapp1/logic/providers/folders_category/folder_selection_provider.dart';
import 'package:notetakingapp1/logic/providers/folders_category/folders_list_provider.dart';
import 'package:notetakingapp1/logic/providers/folders_category/folders_provider.dart';
import 'package:notetakingapp1/logic/providers/home_screen/search_provider.dart';
import 'package:notetakingapp1/logic/utils/utils.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';

class FoldersBody extends ConsumerWidget {
  const FoldersBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(foldersProvider, (prev, next) {
      next.whenData(
          (folders) => ref.read(foldersListProvider.notifier).state = folders);
    });

    final foldersStream = ref.watch(foldersProvider);
    final query = ref.watch(searchProvider).toLowerCase().trim();

    return foldersStream.when(data: (folders) {
      final filteredFolders = query.isEmpty
          ? folders
          : folders
              .where((folder) => (folder['name'] ?? '')
                  .toString()
                  .toLowerCase()
                  .contains(query))
              .toList();

      if (filteredFolders.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 50.0, color: Colors.grey),
              const SizedBox(height: 8.0),
              Text(
                query.isEmpty
                    ? 'No folders yet!\nCreate one.'
                    : 'No results!',
                textAlign: TextAlign.center,
                style: Styles.universalFont(fontSize: 20.0),
              ),
            ],
          ),
        );
      }

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
                crossAxisCount: isDesktop(context)
                    ? 6
                    : isTablet(context)
                        ? 4
                        : 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 150 / 100,
              ),
              itemCount: filteredFolders.length,
              itemBuilder: (context, index) {
                final folder = filteredFolders[index];
                final String folderName = folder['name'] ?? '';

                return Consumer(builder: (context, ref, child) {
                  final selectedFolders = ref.watch(folderSelectionProvider);
                  final bool isFolderSelected =
                      selectedFolders.contains(folder);
                  final folderSelectionNotifier =
                      ref.read(folderSelectionProvider.notifier);
                  final categoryNotifier =
                      ref.read(categoryProvider.notifier);

                  return GestureDetector(
                    onTap: () {
                      categoryNotifier.state = folderName;
                    },
                    onLongPress: () {
                      folderSelectionNotifier.toggleSelection(folder);
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
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.folder,
                                size: 24.0, color: Color(0xFFA67B5B)),
                            const SizedBox(height: 8.0),
                            Text(
                              folderName.isEmpty
                                  ? 'Unnamed Folder'
                                  : folderName,
                              textAlign: TextAlign.center,
                              style: Styles.w600texts(fontSize: 12.0),
                            ),
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
    }, error: (error, stacktrace) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(days: 1),
          content: Text('Error : ${error.toString()}',
              style: Styles.universalFont(fontSize: 16.0))));
      return SizedBox.shrink();
    }, loading: () {
      return Center(
        child: CircularProgressIndicator(color: colorScheme.secondary),
      );
    });
  }
}

