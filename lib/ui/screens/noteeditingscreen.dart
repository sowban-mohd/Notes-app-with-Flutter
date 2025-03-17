import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notetakingapp1/logic/notes_controller.dart';
import 'package:notetakingapp1/logic/services/hive_service.dart';
import 'package:notetakingapp1/ui/theme/styles.dart';

class NoteEditingscreen extends StatefulWidget {
  const NoteEditingscreen({super.key});

  @override
  State<NoteEditingscreen> createState() => _NoteEditingscreenState();
}

class _NoteEditingscreenState extends State<NoteEditingscreen> {
  final _notesController = Get.find<NotesController>();
  final hiveService = HiveService();
  late TextEditingController titleController;
  late TextEditingController contentController;
  late int? key;
  late String titleText;
  late String contentText;

  @override
  void initState() {
    super.initState();
    if (Get.arguments is int) {
      key = Get.arguments as int;
      var note = hiveService.notesBox.get(key);
      titleText = note['title'];
      contentText = note['content'];
    } else {
      key = null;
      titleText = '';
      contentText = '';
    }
    titleController = TextEditingController(text: titleText);
    contentController = TextEditingController(text: contentText);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
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
                    //Back button
                    TextButton.icon(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: colorScheme.primary,
                      ),
                      label: Text(
                        "Back",
                        style: Styles.textButtonStyle(fontSize: 16.0),
                      ),
                    ),
                    //Save button
                    TextButton(
                        onPressed: () async {
                          final title = titleController.text;
                          final content = contentController.text;
                          if (title.isEmpty && content.isEmpty) {
                            Get.showSnackbar(GetSnackBar(
                              message: 'Can\'t save an empty note',
                              duration: Duration(seconds: 5),
                            ));
                          } else {
                            await _notesController.saveNote(
                                key: key,
                                title: titleController.text,
                                content: contentController.text);
                            Get.back();
                          }
                        },
                        child: Text(
                          'Save',
                          style: Styles.textButtonStyle(fontSize: 16.0),
                        ))
                  ]),
            ),
            //Title Field
            Theme(
              data: Styles.textSelectionTheme(),
              child: TextField(
                controller: titleController,
                style: Styles.titleStyle(
                    fontSize: 24.0, color: colorScheme.onSurface),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 22.0),
                    hintText: 'Page Title',
                    hintStyle: Styles.titleStyle(
                      fontSize: 24.0,
                      color: colorScheme.onSurface.withAlpha(66),
                    )),
              ),
            ),

            //Content field
            Expanded(
              child: Theme(
                data: Styles.textSelectionTheme(),
                child: TextField(
                  controller: contentController,
                  style: Styles.w400texts(
                      fontSize: 16.0, color: colorScheme.onSurface),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 24.0, right: 24.0, top: 12.0, bottom: 20.0),
                      hintText: 'Notes goes here...',
                      hintStyle: Styles.w400texts(
                          fontSize: 16.0,
                          color: colorScheme.onSurface.withAlpha(66))),
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
