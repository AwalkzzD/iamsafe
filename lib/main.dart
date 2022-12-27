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
      title: 'SplashScreen',
      home: AnimatedSplashScreen(
        splash: Icons.woman,
        nextScreen: CheckLogin(),
        splashIconSize: 120,
        duration: 2500,
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.amber,
      ),
    );
  }
}
