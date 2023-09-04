import 'package:flutter/material.dart';
import 'dart:async';
import 'home_page.dart';
//for firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int imageIndex = 0;
  List<String> images = ['assets/1.jpg', 'assets/2.jpg'];

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
    _updateView();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  _updateView() {
    Future.delayed(Duration(seconds: 3), () {  // Remove the R after 3
      if (imageIndex < images.length - 1) {
        setState(() {
          imageIndex++;
        });
        _updateView();
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomePage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(images[imageIndex]),
      ),
    );
  }
}
