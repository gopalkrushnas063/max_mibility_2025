import 'package:get/get.dart';
import 'package:max_mobility_assignment/model/User.dart';
import 'package:max_mobility_assignment/service/UserService.dart';

class MyHomePageController extends GetxController {
  var userList = <User>[].obs;
  var isLoading = false.obs;
  final UserService _userService = Get.put(UserService());  // Register UserService

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

  Future<void> deleteUser(int userId) async {
    var result = await _userService.deleteUser(userId);
    if (result != null) {
      getAllUserDetails();
    }
  }
}
