import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
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
  final pinController = TextEditingController();

  Future<void> verifyPhoneNumber(BuildContext context) async {
    // CircularProgressIndicator();
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
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const Text(
                    'Enter your OTP...',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'RobotoSlab',
                      color: Colors.amber,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  ),
                  Container(
                    child: OtpTextField(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'RobotoSlab',
                      ),
                      numberOfFields: 6,
                      borderColor: const Color.fromARGB(255, 255, 191, 0),
                      showFieldAsBox: true,
                      keyboardType: TextInputType.number,
                      margin: EdgeInsets.only(right: 8.0),
                      fieldWidth: 30,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Colors.amber,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Colors.amber,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      ),
                      focusedBorderColor: Colors.amber,
                      onCodeChanged: (String code) {},
                      onSubmit: (String verificationCode) {
                        otp = verificationCode;
                        Navigator.of(context).pop();
                        signIn(otp);
                      },
                    ),
                  ),
                ],
              ),
            ),
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
                padding: const EdgeInsets.fromLTRB(15, 7, 15, 7),
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
