import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:iamsafe/database.dart';
import 'package:iamsafe/home.dart';
import 'dart:async';
import 'package:pinput/pinput.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String userID;
  late String phoneNumber;
  late String verificationId;
  late String otp, authStatus = "";
  final pinController = TextEditingController();

  void customToast(String message, BuildContext context) {
    showToast(message,
        textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(185, 110, 208, 1),
          fontFamily: 'EduNSWACTFoundation',
        ),
        borderRadius: BorderRadius.circular(15),
        animation: StyledToastAnimation.slideFromTopFade,
        position: StyledToastPosition.top,
        animDuration: const Duration(milliseconds: 50),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.purple.shade50,
        context: context);
  }

  Future<void> verifyPhoneNumber(BuildContext context) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 15),
      verificationCompleted: (AuthCredential authCredential) {
        setState(() {
          authStatus = "Your account is successfully verified";
          customToast(authStatus, context);
        });
      },
      verificationFailed: (FirebaseAuthException authException) {
        setState(() {
          authStatus = "Authentication failed";
          customToast(authStatus, context);
        });
      },
      codeSent: (String verId, [int? forceCodeResent]) {
        verificationId = verId;
        setState(() {
          authStatus = "OTP sent successfully";
          customToast(authStatus, context);
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
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const Text(
                    'Enter OTP...',
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'EduNSWACTFoundation',
                      color: Color.fromRGBO(184, 140, 198, 1.0),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                  ),
                  Pinput(
                    length: 6,
                    controller: pinController,
                    androidSmsAutofillMethod:
                        AndroidSmsAutofillMethod.smsRetrieverApi,
                    onCompleted: (value) {
                      otp = value;
                      Navigator.of(context).pop();
                      signIn(otp);
                    },
                    defaultPinTheme: PinTheme(
                      width: 30,
                      height: 50,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Color.fromRGBO(184, 140, 198, 1.0),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromRGBO(184, 140, 198, 1.0)),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> signIn(String otp) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      UserCredential result = await _auth.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: otp));

      User? user = result.user;

      await DatabaseService()
          .addUser(uid: user!.uid, phonenum: user.phoneNumber!);

      // ignore: use_build_context_synchronously
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        customToast('Invalid Code', context);
      } else {
        customToast('Something went wrong!', context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                  color: Color.fromRGBO(184, 140, 198, 1.0),
                  fontSize: 30,
                  fontFamily: 'EduNSWACTFoundation',
                  // fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Image.asset(
                  'assets/IamSafe_new.png',
                  height: 230,
                  width: 230,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 90, 30, 0),
                child: TextField(
                  autocorrect: true,
                  style: const TextStyle(
                    fontSize: 17,
                    fontFamily: 'RobotoSlab',
                    letterSpacing: 2.5,
                    color: Colors.black,
                  ),
                  keyboardType: TextInputType.phone,
                  cursorColor: Color.fromRGBO(184, 140, 198, 1.0),
                  decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 3,
                          color: Color.fromRGBO(184, 140, 198, 1.0),
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 3,
                          color: Color.fromRGBO(184, 140, 198, 1.0),
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      filled: true,
                      prefixIcon: const Icon(
                        Icons.phone_android,
                        color: Color.fromRGBO(184, 140, 198, 1.0),
                      ),
                      hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 15,
                          fontFamily: 'EduNSWACTFoundation',
                          letterSpacing: 0),
                      hintText: "Enter phone number...",
                      fillColor: Colors.purple.shade50),
                  onChanged: (value) {
                    phoneNumber = '+91$value';
                  },
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(15, 7, 15, 7),
                  backgroundColor: Color.fromRGBO(184, 140, 198, 1.0),
                  elevation: 7.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // ignore: unnecessary_null_comparison
                  phoneNumber == null ? null : verifyPhoneNumber(context);
                  customToast('Authentication Started', context);
                  const CircularProgressIndicator();
                },
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
            ],
          ),
        ),
      ),
    );
  }
}
