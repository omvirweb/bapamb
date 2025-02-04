import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jewelbook_calculator/ui/dashboard/dashboard.dart';
import 'package:jewelbook_calculator/ui/login_screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  final SharedPreferences prefs;

  const SplashScreen({super.key, required this.prefs});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      navigateToPage();
    });
  }

  void navigateToPage() {
    bool isLoggedIn = widget.prefs.getBool('isLoggedIn') ?? false;

    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => isLoggedIn ? const Dashboard() : const LoginScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
            child: Card(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 200,
              height: 150,
              child: Image.asset('assets/images/app_icon.png'),
            ),
          ),
        )),
      ),
    );
  }
}
