import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Notifier that manages, exposes initial location path
class IntialLocationNotifier extends AsyncNotifier<String> {
  @override
  Future<String> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('InitialLocation') ?? '/welcome'; // '/welcome' is set as default initial location
  }

  /// Updates the intial location path
  Future<void> setInitialLocation(String newLocation) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('InitialLocation', newLocation);
  }
}

/// Provider of InitalLocationNotifier
final initialLocationProvider =
    AsyncNotifierProvider<IntialLocationNotifier, String>(
  () => IntialLocationNotifier(),
);
