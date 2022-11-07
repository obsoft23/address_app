// ignore_for_file: prefer_const_constructors
import 'package:find_address/screens/home.dart';
import 'package:find_address/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initialPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }

  void initialPage() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    if (prefs != null) {
      Get.offAll(() => HomePage());
    } else {
      Get.offAll(() => WelcomePage());
    }

    //
  }

  //
}
