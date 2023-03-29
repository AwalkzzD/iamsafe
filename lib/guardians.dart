import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iamsafe/database.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
}

class Guardian extends StatefulWidget {
  const Guardian({super.key});

  @override
  State<Guardian> createState() => _GuardianState();
}

class _GuardianState extends State<Guardian> {
  late Map<dynamic, dynamic> _map;
  String guardian1 = "Please Refresh!",
      guardian2 = "Please Refresh!",
      guardian3 = "Please Refresh!";
  late PhoneContact contact;

  @override
  void initState() {
    super.initState();
  }

  Future getGuardians() async {
    final user = FirebaseAuth.instance.currentUser;
    _map = (await DatabaseService().getUser(user!.uid));
    setState(() {
      guardian1 = _map['guardian1'].toString();
      guardian2 = _map['guardian2'].toString();
      guardian3 = _map['guardian3'].toString();
    });
  }

  Future pickContact(String index) async {
    await FlutterContactPicker.requestPermission();
    contact = await FlutterContactPicker.pickPhoneContact();
    // print(contact.phoneNumber.toString());
    setState(() {
      if (index == "1") {
        guardian1 = contact.phoneNumber.toString().substring(20, 30);
        addGuardians("1", guardian1);
      }
      if (index == "2") {
        guardian2 = contact.phoneNumber.toString().substring(20, 30);
        addGuardians("2", guardian2);
      }
      if (index == "3") {
        guardian3 = contact.phoneNumber.toString().substring(20, 30);
        addGuardians("3", guardian3);
      }
    });
  }

  Future addGuardians(String index, String phoneNum) async {
    final user = FirebaseAuth.instance.currentUser;
    if (index == "1") {
      await DatabaseService()
          .addGuardians(uid: user!.uid, field: 'guardian1', value: phoneNum);
    }
    if (index == "2") {
      await DatabaseService()
          .addGuardians(uid: user!.uid, field: 'guardian2', value: phoneNum);
    }
    if (index == "3") {
      await DatabaseService()
          .addGuardians(uid: user!.uid, field: 'guardian3', value: phoneNum);
    }
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
          "Guardians",
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
        child: GridView.count(
          crossAxisCount: 1,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Image.asset(
                      'assets/guardians_illustration.png',
                      scale: 4,
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    const Flexible(
                      child: Text(
                        "Safety and security don't just happen, they are the result of collective consensus and public investment",
                        style: TextStyle(
                          fontFamily: 'EduNSWACTFoundation',
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 30),
              child: Card(
                color: Colors.transparent,
                shadowColor: const Color.fromARGB(255, 139, 188, 228),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Guardian Details:",
                          style: TextStyle(
                              fontFamily: 'RobotoSlab',
                              fontSize: 23,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          width: 60,
                        ),
                        IconButton(
                          onPressed: () => getGuardians(),
                          icon: const Icon(
                            Icons.refresh,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Column(
                      children: [
                        ListTile(
                          title: Text(
                            guardian1,
                            style: const TextStyle(
                                fontFamily: 'RobotoSlab',
                                fontSize: 15,
                                color: Colors.white),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              pickContact('1');
                            },
                            icon: const Icon(
                              Icons.edit,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            guardian2,
                            style: const TextStyle(
                                fontFamily: 'RobotoSlab',
                                fontSize: 15,
                                color: Colors.white),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              pickContact('2');
                            },
                            icon: const Icon(
                              Icons.edit,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            guardian3,
                            style: const TextStyle(
                                fontFamily: 'RobotoSlab',
                                fontSize: 15,
                                color: Colors.white),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              pickContact('3');
                            },
                            icon: const Icon(
                              Icons.edit,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
