import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
                        onPressed: _logout,
                        child: const Text(
                          "LogOut",
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
