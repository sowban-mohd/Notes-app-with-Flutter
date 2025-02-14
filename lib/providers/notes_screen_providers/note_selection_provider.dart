import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectionNotifier extends Notifier<Map<int, bool>> {
  @override
  Map<int, bool> build() => {};

  void toggleSelection(int index) {
    state = {...state, index: !(state[index] ?? false)};
  }

  void clearSelection() {
    state = {};
  }

  bool get isSelectionActive => state.containsValue(true);
}

final selectionProvider =
    NotifierProvider<SelectionNotifier, Map<int, bool>>(SelectionNotifier.new);
