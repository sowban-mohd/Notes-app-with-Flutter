import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:notetakingapp1/logic/providers/folders_providers.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';
import 'package:notetakingapp1/ui/widgets/confirmaton_dialog.dart';
import 'package:notetakingapp1/ui/widgets/save_folder_bottom_sheet.dart';

class AppBarWithFolderOps extends ConsumerWidget
    implements PreferredSizeWidget {
  AppBarWithFolderOps({super.key});

  final String formattedDate =
      DateFormat('d MMMM, yyyy').format(DateTime.now()); //Formatted date

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFolders =
        ref.watch(folderSelectionProvider); //List of selected notes
    final folderSelectionNotifier = ref
        .read(folderSelectionProvider.notifier); //Access to selection notifier

    return AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        title: Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: TextButton.icon(
                  onPressed: () {
                    folderSelectionNotifier.clearSelection();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: const Color(0xFFA67B5B),
                    size: 24.0,
                  ),
                  label: Text('${selectedFolders.length} selected',
                      style: Styles.w500texts(
                          fontSize: 20.0, color: const Color(0xFFA67B5B))),
                ),
              ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0, top: 8.0),
            child: PopupMenuButton(
              icon: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFA67B5B),
                    width: 1,
                  ),
                  color: colorScheme.surface,
                ),
                child: Icon(
                  Icons.more_horiz,
                  size: 15.0,
                  color: const Color(0xFFA67B5B),
                ),
              ),
              color: colorScheme.surfaceContainer,
              constraints: BoxConstraints(minWidth: 120.0),
              itemBuilder: (context) {
                return [
                  if (selectedFolders.length == 1) ...[
                    PopupMenuItem(
                        child: Text(
                          'Edit folder',
                          style: Styles.w500texts(fontSize: 15.0),
                        ),
                        onTap: () {
                          showSaveFolderSheet(
                              context: context, folder: selectedFolders.first);
                        }),
                  ],
                  PopupMenuItem(
                      child: Text(
                        selectedFolders.length == 1
                            ? 'Delete folder'
                            : 'Delete folders',
                        style: Styles.w500texts(fontSize: 15.0),
                      ),
                      onTap: () async {
                        String type = selectedFolders.length > 1
                            ? 'Delete Folders'
                            : 'Delete Folder';
                        bool? confirmed =
                            await showConfirmationDialog(context, type: type);
                        if (confirmed == true) {
                          await ref
                              .read(folderOpsStateProvider.notifier)
                              .deleteFolders(selectedFolders);
                          ref
                              .read(folderSelectionProvider.notifier)
                              .clearSelection();
                        }
                      }),
                ];
              },
            ),
          )
        ]);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
