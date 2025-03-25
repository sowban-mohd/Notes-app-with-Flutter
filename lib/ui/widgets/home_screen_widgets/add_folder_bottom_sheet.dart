import 'package:flutter/material.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';

void showAddFolderSheet(BuildContext context) {
  final TextEditingController folderController = TextEditingController();

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
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add Folder',
                  style: Styles.titleStyle(fontSize: 26.0),
                ),
                const SizedBox(height: 10),
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
