import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// GetX Controller that manages, exposes user type
class UserTypeController extends GetxController {
  var userType = ''.obs;
  var error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserType();
  }

  ///Loads the user type value from shared preferences
  Future<void> _loadUserType() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      userType.value = prefs.getString('UserType') ??
          'New User'; //New user is the default user type
    } catch (e) {
      error.value = 'Failed to load the user type';
    }
  }

  /// Updates the User type with the given user type
  Future<void> updateUserType(String userType) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('UserType', userType);
  }

  /// Reloads the user type value
  Future<void> retry() async {
    error.value = '';
    userType.value = '';
    await _loadUserType();
  }
}
