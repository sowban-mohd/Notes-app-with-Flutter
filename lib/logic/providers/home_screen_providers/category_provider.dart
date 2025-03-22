import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void updateCategory(String category) {
    state == category ? state = null : state = category;
  }
}

final categoryProvider =
    NotifierProvider<CategoryNotifier, String?>(CategoryNotifier.new);
