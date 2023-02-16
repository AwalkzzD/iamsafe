import 'package:flutter/material.dart';
import 'package:iamsafe/home.dart';

class ProfilePage extends StatelessWidget {
  final double coverHeight = 250;
  final double profileHeight = 100;

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            child: const Icon(
              Icons.arrow_back,
            ),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
          title: const Text("IamSafe"),
          backgroundColor: Colors.amber,
        ),
        body: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            buildTop(),
            buildContent(),
          ],
        ),
      ),
    );
  }

  Widget buildTop() {
    final top = coverHeight - profileHeight / 2;
    final bottom = profileHeight / 2 + 10;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: bottom),
          child: buildCoverImage(),
        ),
        Positioned(
          top: top,
          child: buildProfileImage(),
        )
      ],
    );
  }

  Widget buildCoverImage() => Container(
        color: Colors.amber,
        child: Image.asset(
          'assets/IamSafe.png',
          width: double.infinity,
          height: coverHeight,
          fit: BoxFit.cover,
        ),
      );

  Widget buildProfileImage() => CircleAvatar(
        radius: profileHeight / 2 + 10,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: profileHeight / 2,
          child: Image.asset('assets/default_profile_photo.png'),
        ),
      );

  Widget buildContent() {
    return Column(
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        const SizedBox(height: 8),
        const Text(
          'IamSafe User',
          style: TextStyle(
            fontFamily: 'RobotoSlab',
            fontSize: 25,
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              backgroundColor: Colors.amber),
          onPressed: () {},
          child: const Text(
            'Edit Photo',
            style: TextStyle(
              fontFamily: 'RobotoSlab',
            ),
          ),
        )
      ],
    );
  }
}
