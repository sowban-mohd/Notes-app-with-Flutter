import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:notetakingapp1/logic/providers/folders_category/folder_ops_state_provider.dart';
import 'package:notetakingapp1/logic/providers/folders_category/folder_selection_provider.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';
import 'package:notetakingapp1/ui/widgets/confirmaton_dialog.dart';
import 'package:notetakingapp1/ui/widgets/folders_category/save_folder_bottom_sheet.dart';

enum FolderAction { edit, delete }

class AppBarWithFolderOps extends ConsumerWidget
    implements PreferredSizeWidget {
  AppBarWithFolderOps({super.key});

  final String formattedDate =
      DateFormat('d MMMM, yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFolders = ref.watch(folderSelectionProvider);
    final folderSelectionNotifier = ref.read(folderSelectionProvider.notifier);

    return AppBar(
      elevation: 0,
      backgroundColor: colorScheme.surface,
      title: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: TextButton.icon(
          onPressed: () => folderSelectionNotifier.clearSelection(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFFA67B5B),
            size: 24.0,
          ),
          label: Text(
            '${selectedFolders.length} selected',
            style: Styles.w500texts(
                fontSize: 20.0, color: const Color(0xFFA67B5B)),
          ),
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
              switch (action) {
                case FolderAction.edit:
                  showSaveFolderSheet(
                    context: context,
                    folder: selectedFolders.first,
                  );
                  break;
                case FolderAction.delete:
                  final type = selectedFolders.length > 1
                      ? 'Delete Folders'
                      : 'Delete Folder';
                  final confirmed =
                      await showConfirmationDialog(context, type: type);
                  if (confirmed == true) {
                    await ref
                        .read(folderOpsStateProvider.notifier)
                        .deleteFolders(selectedFolders);
                  }
                  break;
              }
              folderSelectionNotifier.clearSelection();
            },
            itemBuilder: (context) {
              return [
                if (selectedFolders.length == 1)
                  PopupMenuItem(
                    value: FolderAction.edit,
                    child: Text('Edit folder',
                        style: Styles.w500texts(fontSize: 15.0)),
                  ),
                PopupMenuItem(
                  value: FolderAction.delete,
                  child: Text(
                    selectedFolders.length == 1
                        ? 'Delete folder'
                        : 'Delete folders',
                    style: Styles.w500texts(fontSize: 15.0),
                  ),
                ),
              ];
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
