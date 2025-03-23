import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryNotifier extends Notifier<String> {
  @override
  String build() => 'All Notes';

  void updateCategory(String category) {
    state = category;
  }
}

final categoryProvider =
    NotifierProvider<CategoryNotifier, String>(CategoryNotifier.new);
