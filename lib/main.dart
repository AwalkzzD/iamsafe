import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iamsafe/checkauth.dart';

Future<void> main() async {
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
        splash: 'assets/splash_screen_image.png',
        nextScreen: CheckLogin(),
        splashIconSize: 300,
        duration: 2000,
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.amber,
      ),
    );
  }
}
