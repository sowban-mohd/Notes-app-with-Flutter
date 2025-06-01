import 'package:flutter/material.dart';
import 'package:notetakingapp1/core/theme/styles.dart';

/// Displays a confirmation dialog before actions like Log Out, Note deletion
Future<bool?> showConfirmationDialog(BuildContext context,
    {required String type}) {
  return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: colorScheme.surfaceContainer,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Container(
            constraints: BoxConstraints(maxWidth: 200, minWidth: 100),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  type,
                  style: Styles.titleStyle(fontSize: 26.0),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.0),
                  child: Text(
                    type == 'Quit App'
                        ? 'Are you sure you want to quit the app?'
                        : type == 'Delete Note'
                            ? 'Are you sure you want to delete this note?'
                            : type == 'Delete Notes'
                                ? 'Are you sure you want to delete these notes?'
                                : type == 'Delete Folder'
                                    ? 'Are you sure you want to delete this folder?'
                                    : type == 'Delete Folders'
                                        ? 'Are you sure you want to delete these folders?'
                                        : 'Are you sure you want to log out?',
                    style: Styles.subtitleStyle(fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
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
                        Navigator.of(context).pop(true);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFf0f0f0),
                          elevation: 0,
                          fixedSize: Size(110, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24))),
                      child: Text(
                        type == 'Quit App'
                            ? 'Quit'
                            : type == 'Log Out'
                                ? 'Log out'
                                : 'Delete',
                        style: Styles.universalFont(
                            color: colorScheme.error, fontSize: 16),
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
