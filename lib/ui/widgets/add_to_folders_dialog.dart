import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/logic/providers/folders_category/folders_list_provider.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';

Future<List<String>?> showAddToFoldersDialog(
    BuildContext context, WidgetRef ref, {String? currentFolder}) {
  final List<String> folders = ref
      .read(foldersListProvider)
      .map((folder) => folder['name'].toString())
      .toList();

  if (currentFolder != null) {
    folders.remove(currentFolder);
  }

  // Use a stateful dialog to track selected checkboxes
  return showDialog<List<String>>(
    context: context,
    builder: (BuildContext context) {
      final selectedFolders = <String>{};

      return Dialog(
        backgroundColor: colorScheme.surfaceContainer,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add to Folders',
                  style: Styles.titleStyle(fontSize: 24.0),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: folders.length,
                    itemBuilder: (context, index) {
                      final folder = folders[index];
                      final isSelected = selectedFolders.contains(folder);
                      return CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          folder,
                          style: Styles.subtitleStyle(fontSize: 16),
                        ),
                        value: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedFolders.add(folder);
                            } else {
                              selectedFolders.remove(folder);
                            }
                          });
                        },
                        activeColor: colorScheme.primary,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFf0f0f0),
                        elevation: 0,
                        fixedSize: Size(110, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: Styles.universalFont(
                          color: colorScheme.onSurface,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          Navigator.of(context).pop(selectedFolders.toList()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFf0f0f0),
                        elevation: 0,
                        fixedSize: Size(110, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        'Save',
                        style: Styles.universalFont(
                          color: colorScheme.primary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        }),
      );
    },
  );
}
