import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.lightGreen, BlendMode.srcIn),
              child: Image.asset("assets/images/top1.png", width: size.width)),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.lightGreen, BlendMode.srcIn),
              child: Image.asset("assets/images/top2.png", width: size.width)),
          ),
          Positioned(
            top: 50,
            right: 40,
            child:Container(
              height: 100,
              width: 100,
              child: Lottie.asset(
                      'assets/images/main.json', // Replace with your JSON file path
                      fit: BoxFit.cover, // Adjust the fit as needed
                    ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.lightGreen, BlendMode.srcIn),
              child: Image.asset("assets/images/bottom1.png", width: size.width)),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.lightGreen, BlendMode.srcIn),
              child: Image.asset(
                "assets/images/bottom2.png",
                width: size.width,
              ),
            ),
          ),
          child
        ],
      ),
    );
  }
}
