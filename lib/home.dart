import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:iamsafe/database.dart';
import 'package:iamsafe/guardians.dart';
import 'package:iamsafe/location.dart';
import 'package:iamsafe/microphone.dart';
import 'package:iamsafe/profilepage.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Map<dynamic, dynamic> _map;
  String phoneNum = "+91XXXXXXXX";
  String userID = "PASJawen2nRL023";
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
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
    return Scaffold(
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
                Icons.mic,
                size: 30,
                color: Colors.white,
              ),
              title: const Text(
                'Microphone',
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
                        builder: (context) => const SoundDetector()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.location_on,
                size: 30,
                color: Colors.white,
              ),
              title: const Text(
                'Location',
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
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  children: [
                    buildCell('Guardians', Icons.spatial_audio_off_rounded),
                    buildCell('Safepoints', Icons.location_on),
                    buildCell('Profile', Icons.person),
                    buildCell('Settings', Icons.settings),
                  ],
                ),
              ),
            ],
          )),
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
        if (text == 'Settings') {
          _logout();
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
