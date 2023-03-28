import 'package:flutter/material.dart';

import 'package:iamsafe/login.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(
      fontSize: 20.0,
      fontFamily: 'EduNSWACTFoundation',
    );
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
        fontFamily: 'RobotoSlab',
        fontSize: 28.0,
        fontWeight: FontWeight.w700,
      ),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 5.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return SafeArea(
        child: IntroductionScreen(
      allowImplicitScrolling: true,
      autoScrollDuration: 3000,
      nextFlex: 1,
      showNextButton: true,
      pages: [
        PageViewModel(
          decoration: pageDecoration,
          title: "Dark clouds of danger around",
          body:
              "Women are constantly facing various obstacles inside and outside the home. For example, the insecurity of travelling, constant sexual harassment and the uncertainty of the proper implementation of the law are hindering the free movement of women.",
          image: Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Image.asset(
              'assets/introduction_screen_1_new.png',
              scale: 2.9,
            ),
          ),
        ),
        PageViewModel(
          decoration: pageDecoration,
          title: "There is a guard on the side",
          body:
              "IamSafe gives you 24/7 digital protection. You will get our help and support directly in danger in any place like roadside, vehicle, workplace. Also your loved ones will get your location. Regular updates.",
          image: Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Image.asset(
              'assets/introduction_screen_2_new.png',
              scale: 2.9,
            ),
          ),
        ),
        PageViewModel(
          decoration: pageDecoration,
          title: "Security Guard",
          body:
              "Be it in city or village, offline or online, your location information will be reported to your loved ones and law enforcement agencies at the push of a button. You will always be in our safety shelter.",
          image: Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Image.asset(
              'assets/introduction_screen_3_new.png',
              scale: 2.9,
            ),
          ),
        ),
      ],
      done: const Text(
        "Get Started",
        style: TextStyle(
          fontFamily: 'RobotoSlab',
          fontWeight: FontWeight.w500,
          color: Color.fromRGBO(184, 140, 198, 1.0),
        ),
      ),
      onDone: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      showSkipButton: true,
      skip: const Text(
        'Skip',
        style: TextStyle(
          fontFamily: 'RobotoSlab',
          fontWeight: FontWeight.w500,
          color: Color.fromRGBO(184, 140, 198, 1.0),
        ),
      ),
      next: const Icon(
        Icons.arrow_forward,
        color: Color.fromRGBO(184, 140, 198, 1.0),
      ),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.grey,
        activeSize: Size(22.0, 10.0),
        activeColor: Color.fromRGBO(184, 140, 198, 1.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    ));
  }
}
