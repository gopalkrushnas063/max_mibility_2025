import 'package:get/get.dart';
import 'package:max_mobility_assignment/model/User.dart';
import 'package:max_mobility_assignment/service/UserService.dart';

class UserController extends GetxController {
  final UserService _userService = UserService();

  var userList = <User>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getAllUserDetails();
  }

  Future<void> getAllUserDetails() async {
    isLoading.value = true;

    var users = await _userService.readAllUsers();
    userList.assignAll(users.map((user) => User.fromJson(user)).toList());

    isLoading.value = false;
  }

  Future<int> saveUser(User user) async {
    var result = await _userService.SaveUser(user);
    getAllUserDetails();
    return result;
  }

  Future<bool> updateUser(User user) async {
    var result = await _userService.UpdateUser(user);
    if (result != null) {
      getAllUserDetails();
      return true;
    }
    return false;
  }

  Future<void> deleteUser(int userId) async {
    var result = await _userService.deleteUser(userId);
    if (result != null) {
      getAllUserDetails();
    }
  }
}
