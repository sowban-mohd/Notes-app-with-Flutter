import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Category{
  allNotes('All Notes'),
  folders('Folders');

  final String categoryName;
  const Category(this.categoryName);
}

final categoryProvider =
    StateProvider<String>((ref) => Category.allNotes.categoryName);
