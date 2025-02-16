import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoteControllers {
  final TextEditingController titleController;
  final TextEditingController contentController;

  NoteControllers({required this.titleController, required this.contentController});
}

final notesControllersProvider = Provider((ref) => NoteControllers(
    titleController: TextEditingController(),
    contentController: TextEditingController()));
