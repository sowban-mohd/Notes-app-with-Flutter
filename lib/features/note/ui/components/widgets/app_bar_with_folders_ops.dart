import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/core/theme/styles.dart';
import 'package:notetakingapp1/features/note/controller/folders_controller.dart';
import 'package:notetakingapp1/features/note/controller/selected_folders_controller.dart';
import 'package:notetakingapp1/features/note/ui/components/widgets/confirmaton_dialog.dart';
import 'package:notetakingapp1/features/note/ui/components/widgets/save_folder_bottom_sheet.dart';

enum FolderAction { edit, delete }

class AppBarWithFolderOps extends ConsumerWidget {
  const AppBarWithFolderOps({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Selection Controller
    final folderSelectionController =
        ref.read(selectedFoldersControllerProvider.notifier);

    final foldersController = ref.read(foldersControllerProvider.notifier);

    //Helper methods
    void clearSelections() => folderSelectionController.clearSelection();

    return AppBar(
      elevation: 0,
      centerTitle: false,
      backgroundColor: colorScheme.surface,
      title: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: TextButton.icon(
          onPressed: () => clearSelections(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFFA67B5B),
            size: 24.0,
          ),
          label: Consumer(builder: (context, ref, _) {
            final selectedFolders =
                ref.watch(selectedFoldersControllerProvider);
            return Text(
              '${selectedFolders.length} selected',
              style: Styles.w500texts(
                  fontSize: 18.0, color: const Color(0xFFA67B5B)),
            );
          }),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0, top: 8.0),
          child: PopupMenuButton<FolderAction>(
            icon: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFA67B5B), width: 1),
                color: colorScheme.surface,
              ),
              child: const Icon(Icons.more_horiz,
                  size: 15.0, color: Color(0xFFA67B5B)),
            ),
            color: colorScheme.surfaceContainer,
            constraints: const BoxConstraints(minWidth: 120.0),
            onSelected: (action) async {
              //Useful values
              final selectedFolders =
                  ref.read(selectedFoldersControllerProvider);
              final isMultipleFoldersSelected = selectedFolders.length > 1;
              final onlySelectedFolder = selectedFolders.first;
              switch (action) {
                case FolderAction.edit:
                  showSaveFolderSheet(
                    context: context,
                    folderId: onlySelectedFolder,
                  );
                  break;
                case FolderAction.delete:
                  final type = isMultipleFoldersSelected
                      ? 'Delete Folders'
                      : 'Delete Folder';
                  final confirmed =
                      await showConfirmationDialog(context, type: type);
                  if (confirmed == true) {
                    await foldersController.deleteFolder(selectedFolders);
                  }
                  break;
              }
              clearSelections();
            },
            itemBuilder: (context) {
              //Useful values
              final selectedFolders =
                  ref.read(selectedFoldersControllerProvider);
              final isOnlyOneFolderSelected = selectedFolders.length == 1;
              return [
                if (isOnlyOneFolderSelected)
                  PopupMenuItem(
                    value: FolderAction.edit,
                    child: Text('Rename folder',
                        style: Styles.w500texts(fontSize: 14.0)),
                  ),
                PopupMenuItem(
                  value: FolderAction.delete,
                  child: Text(
                    isOnlyOneFolderSelected
                        ? 'Delete folder'
                        : 'Delete folders',
                    style: Styles.w500texts(fontSize: 14.0),
                  ),
                ),
              ];
            },
          ),
        ),
      ],
    );
  }
}
