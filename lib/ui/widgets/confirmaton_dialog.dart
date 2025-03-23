import 'package:flutter/material.dart';
import '../theme/styles.dart';

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
          child: Padding(
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
                        : type == 'Log Out'
                            ? 'Are you sure you want to log out?'
                            : type == 'Delete Notes'
                                ? 'Are you sure you want to delete these notes?'
                                : 'Are you sure you want to delete this note?',
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
                        type == 'Log Out'
                            ? 'Log out'
                            : type == 'Quit App'
                                ? 'Quit'
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
