import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Notifier that manages, exposes initial location path
class IntialLocationNotifier extends Notifier<String> {
  @override
  String build() {
    _loadInitialLocation(); //Loads initial screen by updating the state asynchronously
    return '/'; //Fallback screen till the initial screen loads
  }

  Future<void> _loadInitialLocation() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString('InitialLocation') ??
        '/welcome'; // '/welcome' is set as default initial location
  }

  /// Updates the intial location path
  Future<void> setInitialLocation(String newLocation) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('InitialLocation', newLocation);
  }
}

/// Provider of InitalLocationNotifier
final initialLocationProvider =
    NotifierProvider<IntialLocationNotifier, String>(
  () => IntialLocationNotifier(),
);
