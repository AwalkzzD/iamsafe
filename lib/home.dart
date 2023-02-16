import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iamsafe/database.dart';
import 'package:iamsafe/location.dart';
import 'package:iamsafe/microphone.dart';
import 'package:iamsafe/profilepage.dart';

import 'login.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } catch (e) {
      print(e.toString());
    }
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
              accountName: const Text(
                "Feni Patel",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: const Text(
                "patelfeni350@gmail.com",
                style: TextStyle(fontWeight: FontWeight.w300),
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
              leading: const Icon(
                Icons.logout,
              ),
              title: const Text('Logout'),
              onTap: () {
                _logout();
              },
            ),
            ListTile(
              leading: const Icon(Icons.mic),
              title: const Text('Microphone'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SoundDetector()));
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: Future.value(FirebaseAuth.instance.currentUser),
        builder: (context, snapshot) {
          User? user = snapshot.data;

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
                      Text("UserId: ${user!.uid}"),
                      const SizedBox(
                        height: 20,
                      ),
                      Text("Registered Phone Number: ${user.phoneNumber}"),
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
