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
      final selectedPinnedNotes = _selectedNotesController.selectedPinnedNotes;
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
                        Icons.arrow_back_ios_new,
                        color: colorScheme.primary,
                        size: 22.0,
                      ),
                      label: Text('${selectedNotes.length}',
                          style: Styles.textButtonStyle(fontSize: 18.0)),
                    ),
                    IconButton(
                        onPressed: () async {
                          if(selectedPinnedNotes.isEmpty) {
                               await _notesController.pinNote(selectedNotes);
                          } else {
                              await _notesController.unPinNote(selectedNotes);
                               selectedPinnedNotes.clear();
                          }
                          selectedNotes.clear();
                        },
                        icon: selectedPinnedNotes.isEmpty
                            ? SvgPicture.asset(
                                'assets/icons/keep.svg',
                                width: 22,
                                height: 22,
                                colorFilter: ColorFilter.mode(
                                  colorScheme.primary,
                                  BlendMode.srcIn,
                                ),
                              )
                            : SvgPicture.asset(
                                'assets/icons/keep-off.svg',
                                width: 24,
                                height: 24,
                                colorFilter: ColorFilter.mode(
                                  colorScheme.primary,
                                  BlendMode.srcIn,
                                ),
                              )),
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
