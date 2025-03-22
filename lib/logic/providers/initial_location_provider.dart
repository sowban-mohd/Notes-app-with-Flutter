import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntialScreenNotifier extends AsyncNotifier<String> {
  @override
  Future<String> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('InitialLocation') ?? '/welcome';
  }

  Future<void> setInitialLocation(String newLocation) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('InitialLocation', newLocation);
    final screen = prefs.getString('InitialLocation');
    debugPrint('initial screen changed to : $screen');
  }
}

final initialLocationProvider =
    AsyncNotifierProvider<IntialScreenNotifier, String>(
  () => IntialScreenNotifier(),
);
