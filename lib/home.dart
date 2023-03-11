import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iamsafe/database.dart';
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
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => LoginPage()));
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  getData(String uid) async {
    _map = (await DatabaseService().getUser(uid));
    setState(() {
      phoneNum = _map['phoneNum'].toString();
      userID = _map['userID'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IamSafe"),
        backgroundColor: Colors.amber,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.amber,
              ),
              accountName: Text(
                phoneNum,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                userID,
                style: const TextStyle(fontWeight: FontWeight.w300),
              ),
              currentAccountPicture: CircleAvatar(
                child: Image.asset('assets/default_profile_photo.png'),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.mic),
              title: const Text('Microphone'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SoundDetector()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Location'),
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
              ),
              title: const Text('Logout'),
              onTap: () {
                _logout();
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: Future.value(FirebaseAuth.instance.currentUser),
        builder: (context, snapshot) {
          User? user = snapshot.data;
          getData(user!.uid);
          return snapshot.hasData
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "SignIn Success",
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Text("UserId: ${user.uid}"),
                      const SizedBox(
                        height: 20,
                      ),
                      // Text("Registered Phone Number: ${user.phoneNumber}"),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GeoTracking()));
                        },
                        child: const Text(
                          "Add SafePoints",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                )
              : const CircularProgressIndicator();
        },
      ),
    );
  }
}
