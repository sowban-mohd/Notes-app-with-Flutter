import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/logic/providers/folders_category/folder_ops_state_provider.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';

void showSaveFolderSheet({required BuildContext context, Map? folder}) {
  final TextEditingController folderController = TextEditingController();

  //If folder is provided while calling showSaveFolderShee, it indicates bottom sheet is meant for updation
  //Controller text is updated with previous folder name
  if (folder != null) {
    folderController.text = folder['name'];
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
                  folder == null ? 'Add Folder' : 'Edit Folder Name',
                  style: Styles.titleStyle(fontSize: 26.0),
                ),
                const SizedBox(height: 20),
                Theme(
                  data: Styles.textSelectionTheme(),
                  child: TextField(
                      controller: folderController,
                      decoration: InputDecoration(
                          hintText: 'Folder name',
                          hintStyle: Styles.universalFont(),
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
                          fixedSize: Size(110, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24))),
                      child: Text(
                        'Cancel',
                        style: Styles.universalFont(
                            color: colorScheme.onSurface, fontSize: 16),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final providerNotifier =
                            ProviderScope.containerOf(context)
                                .read(folderOpsStateProvider.notifier);
                        if (folder == null) {
                          await providerNotifier
                              .addFolder(folderController.text.trim());
                        } else {
                          await providerNotifier.updateFolder(
                              folder['folderId'], folderController.text.trim());
                        }
                        if (context.mounted) Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFf0f0f0),
                          elevation: 0,
                          fixedSize: Size(110, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24))),
                      child: Text(
                        'Add',
                        style: Styles.universalFont(
                            color: colorScheme.primary, fontSize: 16),
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
