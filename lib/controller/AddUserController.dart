import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:max_mobility_assignment/model/User.dart';
import 'package:max_mobility_assignment/service/UserService.dart';

class AddUserController extends GetxController {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userContactController = TextEditingController();
  final TextEditingController userEmailController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final Rx<File?> imageFile = Rx<File?>(null);
  final picker = ImagePicker();
  final userService = Get.find<UserService>();

  final isLoading = false.obs;

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
  }

  Future<void> fetchLocation() async {
    isLoading.value = true; // Set loading state to true

    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      print('Location permissions are denied');
      isLoading.value = false; // Set loading state to false
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitudeController.text = position.latitude.toString();
      longitudeController.text = position.longitude.toString();
      isLoading.value = false; // Set loading state to false
    } catch (e) {
      print('Error fetching location: $e');
      isLoading.value = false; // Set loading state to false in case of error
    }
  }

  void addUser() async {
    if (userNameController.text.isEmpty ||
        userContactController.text.isEmpty ||
        userEmailController.text.isEmpty) {
      // Handle validation
      return;
    }

    isLoading.value = true;

    var user = User(
      name: userNameController.text,
      contact: userContactController.text,
      email: userEmailController.text,
      imagePath: imageFile.value?.path,
      latitude: latitudeController.text,
      longitude: longitudeController.text,
    );

    try {
      var result = await userService.SaveUser(user);
      isLoading.value = false;

      if (result != null) {
        Get.back(result: true);
      } else {
        // Handle error
        _showError('Error saving user');
      }
    } catch (e) {
      print('Error adding user: $e');
      isLoading.value = false; // Reset loading state in case of error
      _showError('Error adding user');
    }
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    userNameController.dispose();
    userContactController.dispose();
    userEmailController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    imageFile.close(); // Dispose of the Rx subscription
    super.onClose();
  }
}
