import 'package:flutter/material.dart';
import 'package:notetakingapp1/core/theme/styles.dart';

class NoteEditingScreenLayout extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onSave;
  final TextEditingController titleController;
  final TextEditingController contentController;
  final TextStyle buttonTextStyle;
  final Color iconColor;
  final ThemeData textSelectionTheme;
  final Color backgroundColor;

  const NoteEditingScreenLayout({
    super.key,
    required this.onBack,
    required this.onSave,
    required this.titleController,
    required this.contentController,
    required this.buttonTextStyle,
    required this.iconColor,
    required this.textSelectionTheme,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 2.0, right: 10.0, top: 8.0, bottom: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: onBack,
                    icon: Icon(Icons.arrow_back_ios_new, color: iconColor),
                    label: Text("Back", style: buttonTextStyle),
                  ),
                  TextButton(
                    onPressed: onSave,
                    child: Text("Save", style: buttonTextStyle),
                  ),
                ],
              ),
            ),
            Theme(
              data: textSelectionTheme,
              child: TextField(
                controller: titleController,
                style: Styles.titleStyle(
                    fontSize: 22.0, color: colorScheme.onSurface),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 22.0),
                  hintText: 'Page Title',
                  hintStyle: Styles.titleStyle(
                      fontSize: 22.0,
                      color: colorScheme.onSurface.withAlpha(66)),
                ),
              ),
            ),
            Expanded(
              child: Theme(
                data: textSelectionTheme,
                child: TextField(
                  controller: contentController,
                  style: Styles.w400texts(
                      fontSize: 14.0, color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        left: 24.0, right: 24.0, top: 12.0, bottom: 20.0),
                    hintText: 'Notes goes here...',
                    hintStyle: Styles.w400texts(
                        fontSize: 14.0,
                        color: colorScheme.onSurface.withAlpha(66)),
                  ),
                  maxLines: null,
                  expands: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}