import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:iamsafe/database.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Map<dynamic, dynamic> _map;
  late String pn = "",
      uid = "",
      g1 = "",
      g2 = "",
      g3 = "",
      sf1lat = "",
      sf1lon = "",
      sf2lat = "",
      sf2lon = "";

  @override
  void initState() {
    super.initState();
  }

  Future getProfileData() async {
    _map =
        await DatabaseService().getUser(FirebaseAuth.instance.currentUser!.uid);

    setState(() {
      pn = _map['phoneNum'].toString();
      uid = _map['userID'].toString();
      g1 = _map['guardian1'].toString();
      g2 = _map['guardian2'].toString();
      g3 = _map['guardian3'].toString();
      sf1lat = _map['lat1'].toString();
      sf1lon = _map['lon1'].toString();
      sf2lat = _map['lat2'].toString();
      sf2lon = _map['lon2'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(fontFamily: 'EduNSWACTFoundation'),
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
        child: Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const SizedBox(
                height: 110,
              ),
              const Flexible(
                child: Text(
                  "Hello User! You are safe with us! Smile :)",
                  style: TextStyle(
                      fontFamily: 'EduNSWACTFoundation',
                      fontSize: 30,
                      color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              GlassmorphicContainer(
                width: MediaQuery.of(context).size.width - 10,
                height: MediaQuery.of(context).size.height - 250,
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
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text("Profile Data",
                              style: TextStyle(
                                  fontFamily: 'RobotoSlab',
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(width: 120),
                          IconButton(
                              onPressed: getProfileData,
                              icon: const Icon(
                                Icons.refresh,
                                size: 30,
                                color: Colors.white,
                              )),
                        ],
                      ),
                      buildText("Phone Number: ", pn),
                      buildText("User ID: ", uid),
                      buildText("Guardian1: ", g1),
                      buildText("Guardian2: ", g2),
                      buildText("Guardian3: ", g3),
                      buildText("Safepoint1: ", "$sf1lat $sf1lon"),
                      buildText("Safepoint2: ", "$sf2lat $sf2lon"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildText(String label, String data) {
    return Row(
      children: [
        Flexible(
            child: Text(label,
                style: const TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))),
        const SizedBox(
          height: 60,
        ),
        Flexible(
            child: Text(data,
                style: const TextStyle(
                    fontFamily: 'EduNSWACTFoundation',
                    fontSize: 15,
                    color: Colors.white))),
      ],
    );
  }
}
