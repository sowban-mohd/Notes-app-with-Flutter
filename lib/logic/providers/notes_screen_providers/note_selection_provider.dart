import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectionNotifier extends Notifier<Map<int, bool>> {
  @override
  Map<int, bool> build() => {};

  void toggleSelection(int index) {
    state = {...state, index: !(state[index] ?? false)};
  }
}

final selectionProvider =
    NotifierProvider<SelectionNotifier, Map<int, bool>>(SelectionNotifier.new);
