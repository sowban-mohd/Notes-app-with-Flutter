import 'package:flutter/material.dart';

List<Map<dynamic, dynamic>> filterNotes(
    List<Map<dynamic, dynamic>> notes, String query) {
  return query.isEmpty
      ? notes //If query is empty all notes are returned
      : notes
          .where((note) =>
              note['title'].toString().toLowerCase().contains(query) ||
              note['content'].toString().toLowerCase().contains(query))
          .toList();
}

bool isDesktop(context) => MediaQuery.sizeOf(context).width >= 1100;
bool isTablet(context) => MediaQuery.sizeOf(context).width >= 500;
