import 'package:flutter/material.dart';
import 'package:flashchat/Screens/login_screen.dart';
import 'package:flashchat/Screens/registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flashchat/Buttons/roundedbutton.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 3,
      ),
    );
    animation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOutSine);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: animation.value * 100,
                    child: Image.asset(
                      'images/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                DefaultTextStyle(
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                  child: AnimatedTextKit(
                      repeatForever: true,
                      animatedTexts: [FlickerAnimatedText('Flash Chat')]),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Roundedbutton(
                title: 'Log In',
                color: Colors.black87,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
                      },
                    ),
                  );
                }),
            SizedBox(
              width: 20.0,
            ),
            Roundedbutton(
              title: 'Sign Up',
              color: Colors.lightBlueAccent,
              onPress: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return RegistrationScreen();
                  },
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}


