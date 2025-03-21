import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notetakingapp1/logic/state_controllers.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';

class NoteAppBar extends StatelessWidget implements PreferredSizeWidget {
  NoteAppBar({super.key});

  final String formattedDate =
      DateFormat('d MMMM, yyyy').format(DateTime.now()); //Formatted date
  final _selectedNotesController = Get.find<SelectedNotesController>();
  final _notesController = Get.find<NotesController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedNotes = _selectedNotesController.selectedNotes;
      final selectedPinnedNotes = _selectedNotesController.selectedPinnedNotes;

      if (selectedNotes.isEmpty) {
        //Normal app bar
        return AppBar(
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
      } else {
        //App bar when notes are selected
        return AppBar(
            backgroundColor: colorScheme.surfaceContainerLowest,
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      selectedNotes.clear();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: colorScheme.primary,
                      size: 22.0,
                    ),
                    label: Text('${selectedNotes.length}',
                        style: Styles.textButtonStyle(fontSize: 18.0)),
                  ),
                  //If pinned notes are  selected
                  if (selectedPinnedNotes.isNotEmpty)
                    IconButton(
                        onPressed: () async {
                          await _notesController.unPinNote(selectedPinnedNotes);
                          selectedPinnedNotes.clear();
                        },
                        icon: SvgPicture.asset(
                          'assets/icons/keep-off.svg',
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            colorScheme.primary,
                            BlendMode.srcIn,
                          ),
                        ))
                  else
                    IconButton(
                        onPressed: () async {
                          await _notesController.pinNote(selectedNotes);
                          selectedNotes.clear();
                        },
                        icon: SvgPicture.asset(
                          'assets/icons/keep.svg',
                          width: 22,
                          height: 22,
                          colorFilter: ColorFilter.mode(
                            colorScheme.primary,
                            BlendMode.srcIn,
                          ),
                        )),
                ]));
      }
    });
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
