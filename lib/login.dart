// import 'package:flutter/material.dart';
// import 'package:flutter_animated_button/flutter_animated_button.dart';

// void main(List<String> args) {
//   runApp(LoginPage());
// }

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         resizeToAvoidBottomInset: false,
//         appBar: AppBar(
//           title: const Text('IamSafe'),
//           leading: const Icon(
//             Icons.woman,
//             color: Colors.black,
//             size: 45.0,
//           ),
//           backgroundColor: Colors.amber,
//           titleTextStyle: const TextStyle(
//               color: Colors.black, fontSize: 20, fontFamily: 'RobotoSlab'),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               Container(
//                 //Welcome Text Container
//                 padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
//                 margin: const EdgeInsets.all(20.0),
//                 child: const Text(
//                   'Welcome to IamSafe',
//                   style: TextStyle(fontSize: 30.0, fontFamily: 'RobotoSlab'),
//                 ),
//               ),
//               Container(
//                 //Phone Number Input Field (TextField)
//                 padding: const EdgeInsets.fromLTRB(50, 100, 50, 0),
//                 child: TextField(
//                   controller: phoneController,
//                   keyboardType: TextInputType.phone,
//                   cursorColor: Colors.amber,
//                   style: const TextStyle(
//                       fontFamily: 'RobotoSlab',
//                       fontSize: 20.0,
//                       letterSpacing: 2.0),
//                   maxLength: 10,
//                   decoration: const InputDecoration(
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(width: 3, color: Colors.amber),
//                       ),
//                       labelText: 'Enter phone number...',
//                       labelStyle: TextStyle(color: Colors.deepOrangeAccent)),
//                 ),
//               ),
//               Container(
//                 //Password Input Field (TextField)
//                 padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
//                 child: TextField(
//                   controller: passwordController,
//                   obscureText: true,
//                   cursorColor: Colors.amber,
//                   style: const TextStyle(
//                       fontFamily: 'RobotoSlab',
//                       fontSize: 20.0,
//                       letterSpacing: 2.0),
//                   maxLength: 10,
//                   decoration: const InputDecoration(
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(width: 3, color: Colors.amber),
//                       ),
//                       labelText: 'Enter your password...',
//                       labelStyle: TextStyle(color: Colors.deepOrangeAccent)),
//                 ),
//               ),
//               Container(
//                 //Login Button Container
//                 padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
//                 margin: const EdgeInsets.all(0),
//                 child: AnimatedButton(
//                   animatedOn: AnimatedOn.onTap,
//                   text: 'LOGIN',
//                   textStyle: const TextStyle(
//                       color: Colors.black,
//                       fontFamily: 'RobotoSlab',
//                       fontSize: 20.0),
//                   onPress: () {
//                     // print(phoneController.value.text);
//                     // print(passwordController.value.text);
//                   },
//                   height: 50,
//                   width: 150,
//                   selectedTextColor: Colors.black,
//                   transitionType: TransitionType.LEFT_BOTTOM_ROUNDER,
//                   backgroundColor: Colors.amber,
//                   borderColor: Colors.transparent,
//                   borderWidth: 1,
//                 ),
//               ),
//               Container(
//                 //Not a user? Sign Up Text
//                 padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
//                 child: const Text(
//                   'Not a user? Sign Up now',
//                   style: TextStyle(
//                       color: Colors.deepOrange,
//                       fontFamily: 'RobotoSlab',
//                       fontSize: 20.0),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'dart:async';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String phoneNumber, verificationId;
  late String otp, authStatus = "";

  Future<void> verifyPhoneNumber(BuildContext context) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 15),
      verificationCompleted: (AuthCredential authCredential) {
        setState(() {
          authStatus = "Your account is successfully verified";
        });
      },
      verificationFailed: (FirebaseAuthException authException) {
        setState(() {
          authStatus = "Authentication failed";
        });
      },
      codeSent: (String verId, [int? forceCodeResent]) {
        verificationId = verId;
        setState(() {
          authStatus = "OTP has been successfully send";
        });
        otpDialogBox(context).then((value) {});
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
        setState(() {
          authStatus = "TIMEOUT";
        });
      },
    );
  }

  otpDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // ignore: unnecessary_new
          return new AlertDialog(
            title: const Text('Enter your OTP'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                ),
                onChanged: (value) {
                  otp = value;
                },
              ),
            ),
            contentPadding: const EdgeInsets.all(10.0),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  signIn(otp);
                },
                child: const Text(
                  'Submit',
                ),
              ),
            ],
          );
        });
  }

  Future<void> signIn(String otp) async {
    await FirebaseAuth.instance
        .signInWithCredential(PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 100,
            ),
            const Text(
              'Welcome to IamSafe',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 25,
                fontFamily: 'RobotoSlab',
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Image.asset(
                'assets/IamSafe.png',
                height: 230,
                width: 230,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 90, 30, 0),
              child: TextField(
                keyboardType: TextInputType.phone,
                cursorColor: Colors.amber,
                decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.amberAccent,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    filled: true,
                    prefixIcon: const Icon(
                      Icons.phone_android,
                      color: Colors.amber,
                    ),
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    hintText: "Enter phone number...",
                    fillColor: Colors.amber[50]),
                onChanged: (value) {
                  phoneNumber = value;
                },
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
                backgroundColor: Colors.amber,
                elevation: 7.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () =>
                  phoneNumber == null ? null : verifyPhoneNumber(context),
              child: const Text(
                "Generate OTP",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'RobotoSlab',
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              authStatus == "" ? "" : authStatus,
              style: TextStyle(
                  color: authStatus.contains("fail") ||
                          authStatus.contains("TIMEOUT")
                      ? Colors.red
                      : Colors.green),
            )
          ],
        ),
      ),
    );
  }
}
