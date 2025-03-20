import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notetakingapp1/logic/state_controllers.dart';
import 'package:notetakingapp1/ui/screens/screens.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';

class NoteCard extends StatelessWidget {
  final Map<dynamic, dynamic> note;
  final bool isNotePinned;
  NoteCard({super.key, required this.note, required this.isNotePinned});

  final _selectedNotesController = Get.find<SelectedNotesController>();

  @override
  Widget build(BuildContext context) {
    final int key = note['key'];
    final String title = note['title'];
    final String content = note['content'];
    final bool hasTitle = title.trim().isNotEmpty;
    final bool hasContent = content.trim().isNotEmpty;

    return GestureDetector(
        //When tapped
        onTap: () {
      Get.to(() => NoteEditingscreen(
            note: note,
            isNotePinned: isNotePinned,
          ));
    },
        //When long pressed
        onLongPress: () {
      _selectedNotesController.toggleSelection(
          key: key, isPinned: isNotePinned);
    }, child: Obx(() {
      final isSelected = _selectedNotesController.isSelected;
      return Card(
        elevation: isSelected(key) ? 3.0 : 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: isSelected(key)
              ? BorderSide(color: colorScheme.primary, width: 2.0)
              : BorderSide.none,
        ),
        color: colorScheme.surfaceContainer,
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasTitle) ...[
                Text(
                  title,
                  style: Styles.w600texts(
                    color: colorScheme.onSurface,
                    fontSize: 16,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 3),
                Divider(),
                SizedBox(
                  height: 3,
                ),
              ],
              hasContent
                  ? Flexible(
                      child: Text(content,
                          style: Styles.w300texts(
                              color: colorScheme.onSurface, fontSize: 14),
                          overflow: TextOverflow.fade),
                    )
                  : Text(
                      'No content',
                      style: Styles.w300texts(
                          color: colorScheme.onSurface.withAlpha(102),
                          fontSize: 14),
                    ),
            ],
          ),
        ),
      );
    }));
  }
}
