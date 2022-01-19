import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashchat/Screens/welcome_screen.dart';
import 'package:flashchat/chatroom.dart';
import 'package:flashchat/sharedprefferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flashchat/contstant.dart';
import 'package:flashchat/Buttons/roundedbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _saving = false;
  final _auth = FirebaseAuth.instance;
  late String _password;
  final formKey = GlobalKey<FormState>();
  bool isobsecure = true;
  late QuerySnapshot usersnapshot;
  TextEditingController emaileditingcontroller = new TextEditingController();

  late int docs;
  get index => null;

  searchuserbymail(String email) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'images/login.png',
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          floatingActionButton: FloatingActionButton.small(
            onPressed: () {
              Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return WelcomeScreen();
                  },
                ),
              );
            },
            child: Icon(
              Icons.arrow_back_ios_sharp,
              size: 25.0,
              color: Colors.black87,
            ),
          ),
          body: ModalProgressHUD(
            inAsyncCall: _saving,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Hero(
                      tag: 'logo',
                      child: Container(
                        height: 130.0,
                        child: Image.asset('images/logo.png'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 48.0,
                  ),
                  Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emaileditingcontroller,
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val!)
                                  ? null
                                  : "Please Enter Valid E-Mail";
                            },
                            style: TextStyle(color: Colors.white),
                            decoration: textfiel_design,
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          TextFormField(
                            validator: (val) {
                              return val!.length < 6
                                  ? "Please Eneter Password 6+ Character"
                                  : null;
                            },
                            obscureText: isobsecure,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isobsecure = !isobsecure;
                                    });
                                  },
                                  icon: Icon(
                                    isobsecure
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.red,
                                    size: 28.0,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.deepPurple,
                                    width: 12.0,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.0),
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.black26,
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  color: Colors.white70,
                                )),
                            onChanged: (value) {
                              _password = value;
                            },
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 30.0,
                  ),
                  Roundedbutton(
                      title: 'Log In',
                      color: Colors.lightBlueAccent,
                      onPress: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            _saving = true;
                          });
                          sharedprefference.savedusermail(emaileditingcontroller.text);
                        }
                        try {
                          final newuser =
                              await _auth.signInWithEmailAndPassword(
                                  email: emaileditingcontroller.text,
                                  password: _password);
                          if (newuser != null) {
                            sharedprefference.savedloggedinuser(true);
                            sharedprefference
                                .savedusermail(emaileditingcontroller.text);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Chatroomscreen();
                                },
                              ),
                            );
                            setState(() {
                              _saving = false;
                            });
                          }
                        } catch (e) {
                          print(e);
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
