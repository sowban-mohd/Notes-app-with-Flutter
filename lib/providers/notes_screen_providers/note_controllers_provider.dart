import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoteControllers {
  final TextEditingController titleController;
  final TextEditingController contentController;

  NoteControllers(
      {required this.titleController,
      required this.contentController,});

  void dispose() {
    titleController.dispose();
    contentController.dispose();
  }
}

final notesControllersProvider = Provider.autoDispose((ref) {
  final noteControllers = NoteControllers(
    titleController: TextEditingController(),
    contentController: TextEditingController(),
  );

  ref.onDispose(() {
    noteControllers.dispose();
  });
  
  return noteControllers;
});
