import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:max_mobility_assignment/controller/UserController.dart';
import 'package:max_mobility_assignment/screen/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor:
            Colors.lightGreen[700], // Change this color to whatever you want
      ),
    );
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Max Mobility',
      theme: ThemeData(
        // scaffoldBackgroundColor: Colors.lightGreen[100],
        primarySwatch: Colors.lightGreen,
      ),
      home: LoginScreen(),
      initialBinding: BindingsBuilder(() {
        Get.put(UserController());
      }),
    );
  }
}
