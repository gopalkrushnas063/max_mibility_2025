import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:max_mobility_assignment/screen/myhome_page.dart';

class LoginController extends GetxController {
  final String validUsername = 'user@maxmobility.in';
  final String validPassword = 'Abc@#123';

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final RxBool obscureText = true.obs;

  void togglePasswordVisibility() {
    obscureText.value = !obscureText.value;
  }

  void login() {
    String enteredUsername = usernameController.text;
    String enteredPassword = passwordController.text;

    if (enteredUsername == validUsername && enteredPassword == validPassword) {
      Get.dialog(
        AlertDialog(
          title: const Text('Login Successful'),
          content: Text('Welcome, $enteredUsername!'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Get.back();
                Get.off(() => MyHomePage());
              },
            ),
          ],
        ),
      );
    } else {
      Get.dialog(
        AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Username or password is incorrect.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
      );
    }
  }
}