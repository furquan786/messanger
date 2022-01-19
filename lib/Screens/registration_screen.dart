import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashchat/Screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flashchat/contstant.dart';
import 'package:flashchat/Buttons/roundedbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flashchat/Screens/login_screen.dart';
import 'package:flashchat/sharedprefferences.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool isobsecure = true;
  bool _saving = false;
  TextEditingController usernametexteditinngcontroller =
      TextEditingController();
  TextEditingController emailtexteditinngcontroller = TextEditingController();
  TextEditingController passwordtexteditinngcontroller =
      TextEditingController();

  final _auth = FirebaseAuth.instance;
  late String username;
  late String _email;
  late String _password;
  final formKey = GlobalKey<FormState>();

  useronfo(usermap, uid) {
    FirebaseFirestore.instance.collection('users').doc(uid).set(usermap);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'images/signup.jpg',
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
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
          backgroundColor: Colors.transparent,
          body: ModalProgressHUD(
            inAsyncCall: _saving,
            progressIndicator: CircularProgressIndicator.adaptive(),
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: usernametexteditinngcontroller,
                          validator: (val) {
                            return val!.length < 3
                                ? 'Please Enter Valid UserName'
                                : null;
                          },
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 12.0,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.black26,
                              hintText: 'User Name',
                              hintStyle: TextStyle(
                                color: Colors.white70,
                              )),
                          onChanged: (value) {
                            username = value;
                          },
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        TextFormField(
                          controller: emailtexteditinngcontroller,
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val!)
                                ? null
                                : "Please Enter Valid E-Mail";
                          },
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                          decoration: textfiel_design,
                          onChanged: (value) {
                            _email = value;
                          },
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        TextFormField(
                          controller: passwordtexteditinngcontroller,
                          validator: (val) {
                            return val!.length < 6
                                ? "Please Eneter Password 6+ Character"
                                : null;
                          },
                          textAlign: TextAlign.center,
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
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Flexible(
                    child: Roundedbutton(
                      title: 'Sign Up',
                      color: Colors.red,
                      onPress: () async {
                        if (formKey.currentState!.validate()) {
                          Map<String, String> userinfmap = {
                            'username': username,
                          };

                          setState(() {
                            _saving = true;
                          });
                          sharedprefference.savedusername(username);
                          sharedprefference.savedusermail(_email);

                          try {
                            final newuser =
                                await _auth.createUserWithEmailAndPassword(
                                    email: _email, password: _password);
                            useronfo(userinfmap, newuser.user!.uid);
                            print(newuser);
                            if (newuser != null) {
                              sharedprefference.savedloggedinuser(true);
                              usernametexteditinngcontroller.clear();
                              emailtexteditinngcontroller.clear();
                              passwordtexteditinngcontroller.clear();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return LoginScreen();
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
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
