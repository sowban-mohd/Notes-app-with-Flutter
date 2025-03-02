import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// GetX Controller that manages, exposes user type
class UserTypeController extends GetxController {
  var userType = 'isLoading'.obs;

  @override
  void onInit(){
    super.onInit();
    _loadUserType();
  }

  Future<void> _loadUserType() async {
    final prefs = await SharedPreferences.getInstance();
    userType.value = prefs.getString('UserType') ??
        'New User'; //New user is the default user type
  }

  /// Updates the User type
  Future<void> updateUserType(String userType) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('UserType', userType);
  }
}
