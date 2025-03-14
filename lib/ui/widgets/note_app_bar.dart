import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notetakingapp1/logic/selected_notes_controller.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';

class NoteAppBar extends StatelessWidget implements PreferredSizeWidget {
  NoteAppBar({super.key});

  final String formattedDate =
      DateFormat('d MMMM, yyyy').format(DateTime.now()); //Formatted date
  final _selectedNotesController = Get.find<SelectedNotesController>();
  

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedNotes = _selectedNotesController.selectedNotes;

      return selectedNotes.isNotEmpty
          ?
          //App bar when notes are selected
          AppBar(
              backgroundColor: colorScheme.surfaceContainerLowest,
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        selectedNotes.clear();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: colorScheme.onSurface,
                        size: 20.0,
                      ),
                      label: Text('${selectedNotes.length} selected',
                          style: Styles.w500texts(
                              fontSize: 20.0, color: colorScheme.onSurface)),
                    ),
                  ]))
          :
          //Normal app bar
          AppBar(
              elevation: 0.0,
              backgroundColor: colorScheme.surface,
              title: Padding(
                padding: EdgeInsets.only(left: 6.0, right: 6.0, top: 10.0),
                child:
                    //Date and Title
                    Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formattedDate,
                      style: Styles.w400texts(
                        fontSize: 12.0,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      'Notes',
                      style: Styles.titleStyle(fontSize: 24.0),
                    ),
                  ],
                ),
              ),
            );
    });
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
