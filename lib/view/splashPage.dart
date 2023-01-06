import 'dart:async';

import 'package:flutter/material.dart';

import 'loginPage.dart';

class SplashPage extends StatefulWidget {
  @override
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
              color: Colors.black,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset('assets/images/homeStay.png'),
                    const CircularProgressIndicator(
                      color: Color.fromARGB(255, 5, 130, 232),
                    ),
                  ]))),
    );
  }
}