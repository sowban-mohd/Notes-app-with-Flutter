import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/core/theme/styles.dart';
import 'package:notetakingapp1/features/note/controller/folders_controller.dart';
import 'package:notetakingapp1/features/note/models/folder.dart';

void showSaveFolderSheet({required BuildContext context, String? folderId}) {
  final TextEditingController folderController = TextEditingController();

  final folderControllerNotifier = ProviderScope.containerOf(context)
      .read(foldersControllerProvider.notifier);

  Folder? folder;

  //If folder is provided while calling showSaveFolderSheet, it indicates bottom sheet is meant for updation
  //Controller text is updated with previous folder name
  if (folderId != null) {
    final foldersList =
        ProviderScope.containerOf(context).read(foldersListProvider);
    folder = foldersList.firstWhere((folder) => folder.id == folderId);
    folderController.text = folder.name;
  }

  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(24),
            constraints: BoxConstraints(maxWidth: 400, minWidth: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  folder == null ? 'Add Folder' : 'Rename Folder',
                  style: Styles.titleStyle(fontSize: 20.0),
                ),
                const SizedBox(height: 20),
                Theme(
                  data: Styles.textSelectionTheme(),
                  child: TextField(
                      controller: folderController,
                      decoration: InputDecoration(
                          hintText: 'Folder name',
                          hintStyle: Styles.universalFont(fontSize: 14),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: colorScheme.outline,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ))),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFf0f0f0),
                          elevation: 0,
                          fixedSize: Size(100, 35),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24))),
                      child: Text(
                        'Cancel',
                        style: Styles.universalFont(
                            color: colorScheme.onSurface, fontSize: 14),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (folder == null) {
                          await folderControllerNotifier
                              .createFolder(folderController.text.trim());
                        } else {
                          await folderControllerNotifier.renameFolder(
                              updatedName: folderController.text.trim(),
                              folderId: folderId!);
                        }
                        if (context.mounted) Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFf0f0f0),
                          elevation: 0,
                          fixedSize: Size(100, 35),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24))),
                      child: Text(
                        'Add',
                        style: Styles.universalFont(
                            color: colorScheme.primary, fontSize: 14),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      });
}
