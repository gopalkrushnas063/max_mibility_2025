import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:max_mobility_assignment/controller/AddUserController.dart';

class AddUser extends StatelessWidget {
  final AddUserController _controller = Get.put(AddUserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add User", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.lightGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // This makes all icons white
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _controller.userNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Name',
                    labelText: 'Name',
                  ),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: _controller.userContactController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Contact',
                    labelText: 'Contact',
                  ),
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: _controller.userEmailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Email Address',
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller.latitudeController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Latitude',
                          labelText: 'Latitude',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: TextField(
                        controller: _controller.longitudeController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Longitude',
                          labelText: 'Longitude',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightGreen,
                          ),
                          onPressed: _controller.fetchLocation,
                          child: const Icon(
                            Icons.location_on_outlined,
                            color: Colors.white,
                          ),
                        ),
                        if (_controller.isLoading.value)
                          const Positioned(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: _controller.pickImage,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () =>
                            _controller.imageFile.value != null
                                ? Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      _controller.imageFile.value!,
                                      height: 200,
                                      width: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                                : Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.image,
                                      size: 100,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_controller.userNameController.text.isEmpty) {
                      _showErrorSnackBar(context, 'Name field cannot be empty');
                      return;
                    }

                    if (_controller.userContactController.text.length != 10) {
                      _showErrorSnackBar(
                        context,
                        'Contact number must be 10 digits',
                      );
                      return;
                    }

                    if (_controller.userEmailController.text.isEmpty ||
                        !_isValidEmail(_controller.userEmailController.text)) {
                      _showErrorSnackBar(
                        context,
                        'Please enter a valid email address',
                      );
                      return;
                    }

                    if (_controller.imageFile.value == null) {
                      _showErrorSnackBar(context, 'Please pick an image');
                      return;
                    }

                    if (_controller.latitudeController.text.isEmpty ||
                        _controller.longitudeController.text.isEmpty) {
                      _showErrorSnackBar(context, 'Please fetch location');
                      return;
                    }

                    _controller.addUser();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    minimumSize: const Size(double.infinity, 0),
                    backgroundColor: Colors.lightGreen,
                  ),
                  child: const Text(
                    'Add User',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
