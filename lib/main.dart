import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iamsafe/checkauth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SplashScreen());
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SplashScreen',
      home: AnimatedSplashScreen(
        splash: 'assets/splash_screen_image_2.png',
        nextScreen: const CheckLogin(),
        splashIconSize: 800,
        duration: 2000, //change back to 2000 later
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.purple.shade50,
      ),
    );
  }
}
