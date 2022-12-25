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
      //SplashScreen Code
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
      resizeToAvoidBottomInset: false,
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              //Welcome Text Container
              padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
              margin: const EdgeInsets.all(20.0),
              child: const Text(
                'Welcome to IamSafe',
                style: TextStyle(fontSize: 30.0, fontFamily: 'RobotoSlab'),
              ),
            ),
            Container(
              //Phone Number Input Field (TextField)
              padding: const EdgeInsets.fromLTRB(50, 100, 50, 0),
              child: const TextField(
                keyboardType: TextInputType.phone,
                cursorColor: Colors.amber,
                style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 20.0,
                    letterSpacing: 2.0),
                maxLength: 10,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.amber),
                    ),
                    labelText: 'Enter phone number...',
                    labelStyle: TextStyle(color: Colors.deepOrangeAccent)),
              ),
            ),
            Container(
              //Password Input Field (TextField)
              padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: const TextField(
                obscureText: true,
                cursorColor: Colors.amber,
                style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 20.0,
                    letterSpacing: 2.0),
                maxLength: 10,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.amber),
                    ),
                    labelText: 'Enter your password...',
                    labelStyle: TextStyle(color: Colors.deepOrangeAccent)),
              ),
            ),
            Container(
              //Login Button Container
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
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
            Container(
              //Not a user? Sign Up Text
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: const Text(
                'Not a user? Sign Up now',
                style: TextStyle(
                    color: Colors.deepOrange,
                    fontFamily: 'RobotoSlab',
                    fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
