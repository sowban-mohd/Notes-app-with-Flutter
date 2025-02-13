import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notetakingapp1/providers/controllers_provider.dart';

class NoteControllers {
  final TextEditingController titleController;
  final TextEditingController contentController;

  NoteControllers(this.titleController, this.contentController);
}

final notesControllersProvider = Provider((ref) => NotesController(
    titleController: TextEditingController(),
    contentController: TextEditingController()));
