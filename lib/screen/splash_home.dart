import 'package:flutter/material.dart';
import 'package:IntelliHome/constants/app_colors.dart';
// import 'package:IntelliHome/screen/Auth/Login/login_page.dart';
// import 'package:IntelliHome/screen/home.dart';

import 'Auth/Login/login_page.dart';

class SplashHome extends StatefulWidget {
  const SplashHome({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SplashHome> createState() => _SplashHomeState();
}

class _SplashHomeState extends State<SplashHome> {
  @override
  void initState() {
    var splashDuration = const Duration(seconds: 4);
    // Delay for 4 seconds to show the splash screen
    Future.delayed(splashDuration, () {
      // Navigate to the login page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColor.fgColor,
              // gradient: LinearGradient(
              //     colors: [(new Color(0xFF42A5F5)), (new Color(0xFF7E57C2))],
              //     begin: Alignment.topCenter,
              //     end: Alignment.bottomCenter
              // ),
            ),
          ),
          Center(
            child: Container(
              child: Text("IntelliHome", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white,),),
            ),
          ),
        ],
      ),
    );
  }
}