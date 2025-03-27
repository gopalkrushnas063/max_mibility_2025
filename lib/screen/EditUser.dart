import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:max_mobility_assignment/controller/UserController.dart';
import 'package:max_mobility_assignment/model/User.dart';
import 'package:geolocator/geolocator.dart';

class EditUser extends StatefulWidget {
  final User user;

  EditUser({Key? key, required this.user}) : super(key: key);

  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userContactController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  final Rx<File?> _imageFile = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();
  final UserController _userController = Get.find();
  final RxString _latitude = ''.obs;
  final RxString _longitude = ''.obs;
  final RxBool _isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    _userNameController.text = widget.user.name ?? '';
    _userContactController.text = widget.user.contact ?? '';
    _userEmailController.text = widget.user.email ?? '';
    _imageFile.value =
        widget.user.imagePath != null ? File(widget.user.imagePath!) : null;
    _latitude.value = widget.user.latitude ?? '';
    _longitude.value = widget.user.longitude ?? '';
  }

  Future<void> _fetchLocation() async {
    _isLoading.value = true;

    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      print('Location permissions are denied');
      _isLoading.value = false;
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _latitude.value = position.latitude.toString();
        _longitude.value = position.longitude.toString();
        _isLoading.value = false;
      });
    } catch (e) {
      print('Error fetching location: $e');
      _isLoading.value = false;
    }
  }

  void pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _imageFile.value = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit User", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.lightGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // This makes all icons white
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              TextField(
                controller: _userNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Name',
                  labelText: 'Name',
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _userContactController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Contact',
                  labelText: 'Contact',
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _userEmailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Email Address',
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 20.0),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: TextField(
                      readOnly: true,
                      controller: TextEditingController(text: _latitude.value),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Latitude',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      readOnly: true,
                      controller: TextEditingController(text: _longitude.value),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Longitude',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                    ),
                    onPressed: _fetchLocation,
                    child:
                        _isLoading.value
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Icon(
                              Icons.location_on_outlined,
                              color: Colors.white,
                            ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: pickImage,
                  child: const Text('Update Image'),
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: Obx(
                  () =>
                      _imageFile.value != null
                          ? Image.file(
                            _imageFile.value!,
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          )
                          : widget.user.imagePath != null
                          ? Image.file(
                            File(widget.user.imagePath!),
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          )
                          : const SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.teal,
                      textStyle: const TextStyle(fontSize: 15),
                    ),
                    onPressed: () async {
                      String name = _userNameController.text.trim();
                      if (name.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Error"),
                              content: const Text("Please enter a name."),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        return;
                      }

                      String contact = _userContactController.text.trim();
                      if (contact.length != 10) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Error"),
                              content: const Text(
                                "Please enter a valid 10-digit contact number.",
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        return;
                      }

                      String email = _userEmailController.text.trim();
                      bool isEmailValid = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(email);
                      if (!isEmailValid) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Error"),
                              content: const Text(
                                "Please enter a valid email address.",
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        return;
                      }

                      User updatedUser = User(
                        id: widget.user.id,
                        name: name,
                        contact: contact,
                        email: email,
                        imagePath:
                            _imageFile.value?.path ?? widget.user.imagePath,
                        latitude: _latitude.value,
                        longitude: _longitude.value,
                      );

                      var result = await _userController.updateUser(
                        updatedUser,
                      );
                      if (result != null) {
                        Get.back(result: result);
                      }
                    },
                    child: const Text('Update Details'),
                  ),
                  const SizedBox(width: 10.0),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      textStyle: const TextStyle(fontSize: 15),
                    ),
                    onPressed: () {
                      _userNameController.text = '';
                      _userContactController.text = '';
                      _userEmailController.text = '';
                    },
                    child: const Text('Clear Details'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
