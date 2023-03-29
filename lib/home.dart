import 'dart:async';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:iamsafe/checklocation.dart';
import 'package:iamsafe/database.dart';
import 'package:iamsafe/guardians.dart';
import 'package:iamsafe/location.dart';
import 'package:iamsafe/microphone.dart';
import 'package:iamsafe/profilepage.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Map<dynamic, dynamic> _map;
  String phoneNum = "+91XXXXXXXX";
  String userID = "PASJawen2nRL023";
  List<Offset> _points = [];
  late double _startAngle;
  late Offset _startPosition;

  @override
  void initState() {
    super.initState();
    AndroidAlarmManager.cancel(2);
    AndroidAlarmManager.initialize();
    AndroidAlarmManager.periodic(
      const Duration(days: 1),
      2,
      timerFunction,
      startAt: DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 02, 49, 0, 0, 0),
      exact: true,
      wakeup: true,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _isCircle() {
    if (_points.length < 3) return false;

    final p1 = _points[0];
    final p2 = _points[_points.length ~/ 2];
    final p3 = _points.last;
    final radius = (p1 - p2).distance;
    final distanceToCenter = (p3 - (p1 + p2) / 2).distance;
    return distanceToCenter <= radius / 2;
  }

  void customToast(String message, BuildContext context) {
    showToast(
      message,
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
      context: context,
    );
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  showAboutDialog(BuildContext context) {
    // Create button
    Widget okButton = TextButton(
      child: const Text("Yes"),
      onPressed: () {
        // Navigator.of(context).pop();
        Navigator.pop(context);
        _logout();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(
        "Logout",
        style: TextStyle(fontFamily: 'RobotoSlab'),
      ),
      content: const Text(
        "Do you want to logout?",
        style: TextStyle(fontFamily: 'EduNSWACTFoundation', fontSize: 20),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void callTimer() {}
  static void timerFunction() async {
    LocationCheck locationCheck = LocationCheck();
    locationCheck.getData();
    locationCheck.checkGeoFence();

    // ignore: avoid_print
    print("Timer achieved");
  }

  getData(String? uid) async {
    _map = (await DatabaseService().getUser(uid!));
    setState(() {
      phoneNum = _map['phoneNum'].toString();
      userID = _map['userID'].toString();
    });
  }

  Future _getUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    getData(user?.uid);
    if (user == null) {
      return const CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    _getUserDetails();
    return GestureDetector(
      onPanStart: (details) {
        _startPosition = details.localPosition;
        _startAngle = 0.0;
      },
      onPanUpdate: (details) {
        Offset newPosition = details.localPosition;
        double dx = newPosition.dx - _startPosition.dx;
        double dy = newPosition.dy - _startPosition.dy;
        double angle = atan2(dy, dx);
        double distance = sqrt(dx * dx + dy * dy);
        if (_startAngle == 0.0) {
          _startAngle = angle;
        } else {
          double deltaAngle = angle - _startAngle;
          if (deltaAngle.abs() >= pi * 2.0 / 3.0 && distance < 70.0) {
            print('Gesture was a circle!');
            customToast("Emergency Mode Started", context);
            setState(() {
              _startAngle = 0;
              _startPosition = const Offset(0, 0);
            });
          }
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0,
          title: const Text(
            "IamSafe",
            style: TextStyle(fontFamily: 'EduNSWACTFoundation'),
          ),
        ),
        drawer: GlassmorphicContainer(
          width: MediaQuery.of(context).size.width / 1.3,
          height: MediaQuery.of(context).size.height,
          borderRadius: 20,
          border: 2,
          blur: 20,
          linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFffffff).withOpacity(0.1),
                const Color(0xFFFFFFFF).withOpacity(0.05),
              ],
              // ignore: prefer_const_literals_to_create_immutables
              stops: [
                0.1,
                1,
              ]),
          borderGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFffffff).withOpacity(0.5),
              const Color((0xFFFFFFFF)).withOpacity(0.5),
            ],
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(70, 111, 165, 1),
                ),
                accountName: Text(
                  phoneNum,
                  style: const TextStyle(
                      fontFamily: 'EduNSWACTFoundation', fontSize: 20),
                ),
                accountEmail: Text(
                  userID,
                  style: const TextStyle(
                      fontFamily: 'EduNSWACTFoundation', fontSize: 15),
                ),
                currentAccountPicture: CircleAvatar(
                  child: Image.asset('assets/default_profile_photo.png'),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.white,
                ),
                title: const Text(
                  'Profile',
                  style: TextStyle(
                    fontFamily: 'EduNSWACTFoundation',
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilePage()));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.location_on,
                  size: 30,
                  color: Colors.white,
                ),
                title: const Text(
                  'Safepoints',
                  style: TextStyle(
                    fontFamily: 'EduNSWACTFoundation',
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GeoTracking()));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  size: 30,
                  color: Colors.white,
                ),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    fontFamily: 'EduNSWACTFoundation',
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  _logout();
                },
              ),
            ],
          ),
        ),
        body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color.fromRGBO(99, 135, 212, 1),
                  Color.fromRGBO(99, 135, 212, 1),
                  Color.fromRGBO(62, 73, 174, 1),
                  Color.fromRGBO(77, 121, 186, 1),
                ],
              ),
            ),
            child: GridView.count(
              crossAxisCount: 1,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Row(
                      children: [
                        const Flexible(
                          child: Text(
                            'Correction does much, but encouragement does more.',
                            style: TextStyle(
                              fontFamily: 'EduNSWACTFoundation',
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Image.asset(
                          'assets/home_screen_illustration.png',
                          scale: 5,
                        ),
                      ],
                    )),
                Container(
                  margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    children: [
                      buildCell('Guardians', Icons.spatial_audio_off_rounded),
                      buildCell('Safepoints', Icons.location_on),
                      buildCell('Profile', Icons.person),
                      buildCell('Logout', Icons.logout),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget buildCell(String text, IconData icon) {
    return GestureDetector(
      onTap: () {
        if (text == 'Guardians') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Guardian()));
        }
        if (text == 'Safepoints') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const GeoTracking()));
        }
        if (text == 'Profile') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ProfilePage()));
        }
        if (text == 'Logout') {
          showAboutDialog(context);
          // _logout();
        }
      },
      child: GlassmorphicContainer(
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.height,
        borderRadius: 20,
        border: 2,
        blur: 2,
        linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFffffff).withOpacity(0.1),
              const Color(0xFFFFFFFF).withOpacity(0.05),
            ],
            stops: [
              0.1,
              1,
            ]),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFffffff).withOpacity(0.5),
            const Color((0xFFFFFFFF)).withOpacity(0.5),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.white,
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                text,
                style: const TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
