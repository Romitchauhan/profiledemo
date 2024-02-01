import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: SplashScreen(),
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
         // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace 'logo.png' with your logo image asset
          Expanded(
            child: Container(
width: double.infinity,
              child: Image(image:   AssetImage('assets/images/welcome.jpg'),
              fit: BoxFit.fill,
              ),
            ),
          )
            //SizedBox(height: 20),
           // CircularProgressIndicator(), // Optional: Add loading indicator
          ],
        ),
      ),
    );
  }
}
