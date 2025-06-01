import 'package:flutter/material.dart';
import 'package:notetakingapp1/features/notes/models/note.dart';

class Utils {
  /// Filters the list of notes based on search query
  static List<Note> filterNotes(List<Note> notes, String query) {
    return notes
        .where((note) =>
            note.title.toString().toLowerCase().contains(query) ||
            note.content.toString().toLowerCase().contains(query))
        .toList();
  }

  static showSnackbar(BuildContext context, String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    });
  }

  static bool isDesktop(context) => MediaQuery.sizeOf(context).width >= 1100;
  static bool isTablet(context) => MediaQuery.sizeOf(context).width >= 500;
}
