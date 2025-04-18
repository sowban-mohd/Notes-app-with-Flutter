import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/logic/providers/category_provider.dart';
import 'package:notetakingapp1/logic/providers/folder_selection_provider.dart';
import 'package:notetakingapp1/logic/providers/body_stream_provider.dart';
import 'package:notetakingapp1/logic/utils/utils.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';

class FoldersBody extends ConsumerWidget {
  const FoldersBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersStream = ref.watch(bodyStreamProvider);
    return foldersStream.when(data: (folders) {
      return folders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.create_new_folder_outlined,
                    size: 50.0,
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  Text('No folders yet!\nCreate one.',
                      textAlign: TextAlign.center,
                      style: Styles.universalFont(fontSize: 20.0)),
                ],
              ),
            )
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.only(top: 12.0, left: 16.0, bottom: 8.0),
                child: Text(
                  'Folders',
                  style: Styles.noteSectionTitle(),
                ),
              ),
              SizedBox(
                height: 6,
              ),
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
                  itemCount: folders.length,
                  itemBuilder: (context, index) {
                    final folder = folders[index];
                    final String folderName = folder['name'];
                    //Folder card
                    return Consumer(builder: (context, ref, child) {
                      final selectedFolders =
                          ref.watch(folderSelectionProvider);
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
                                ? BorderSide(
                                    color: const Color(0xFFA67B5B), width: 2.0)
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
            ]);
    }, error: (error, stacktrace) {
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
      return SizedBox.shrink();
    }, loading: () {
      return Center(
        child: CircularProgressIndicator(color: colorScheme.secondary),
      );
    });
  }
}
