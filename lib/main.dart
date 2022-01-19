import 'package:flashchat/Screens/search_screen.dart';
import 'package:flashchat/chatroom.dart';
import 'package:flashchat/sharedprefferences.dart';
import 'package:flutter/material.dart';
import 'package:flashchat/Screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
   runApp(Flashchat());
}

class Flashchat extends StatefulWidget {
  @override
  State<Flashchat> createState() => _FlashchatState();
}

class _FlashchatState extends State<Flashchat> {
  bool userloggedin = false;

  getuserloggedin() async {
    await sharedprefference.savedloggedinuser(true).then((value) {
      setState(() {
        userloggedin = true;
      });
    });
  }

  @override
  void initState() {
   getuserloggedin();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyText1: TextStyle(
            color: Colors.black54,
          ),
        ),
      ),
      home: userloggedin ? Chatroomscreen() : WelcomeScreen(),
      // initialRoute: 'welcomescreen',
      // routes: {
      //   'welcomescreen': (context) => WelcomeScreen(),
      // },
    );
  }
}
