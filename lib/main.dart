import 'dart:ui';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';

void main() {
  runApp(const SplashScreen());
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      home: AnimatedSplashScreen.withScreenFunction(
        splash: Icons.woman,
        splashIconSize: 120,
        duration: 3000,
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.amber,
        screenFunction: () async {
          return const MainScreen();
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IamSafe'),
        leading: const Icon(
          Icons.woman,
          color: Colors.black,
          size: 45.0,
        ),
        backgroundColor: Colors.amber,
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 20, fontFamily: 'RobotoSlab'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              //Text Container
              padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
              margin: const EdgeInsets.all(20.0),
              child: const Text(
                'Welcome to IamSafe',
                style: TextStyle(fontSize: 30.0, fontFamily: 'RobotoSlab'),
              ),
            ),
            Container(
              //Signup Button Container
              padding: const EdgeInsets.fromLTRB(0, 200, 0, 0),
              margin: const EdgeInsets.all(20),
              child: AnimatedButton(
                animatedOn: AnimatedOn.onTap,
                text: 'SIGN UP',
                textStyle: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'RobotoSlab',
                    fontSize: 20.0),
                onPress: () {},
                height: 50,
                width: 150,
                selectedTextColor: Colors.black,
                transitionType: TransitionType.LEFT_BOTTOM_ROUNDER,
                backgroundColor: Colors.amber,
                borderColor: Colors.transparent,
                borderWidth: 1,
              ),
            ),
            Container(
              //Login Button Container
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              margin: const EdgeInsets.all(0),
              child: AnimatedButton(
                animatedOn: AnimatedOn.onTap,
                text: 'LOGIN',
                textStyle: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'RobotoSlab',
                    fontSize: 20.0),
                onPress: () {},
                height: 50,
                width: 150,
                selectedTextColor: Colors.black,
                transitionType: TransitionType.LEFT_BOTTOM_ROUNDER,
                backgroundColor: Colors.amber,
                borderColor: Colors.transparent,
                borderWidth: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
