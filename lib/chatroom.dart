import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat/Screens/chat_screen.dart';
import 'package:flashchat/Screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flashchat/contstant.dart';
import 'package:flashchat/sharedprefferences.dart';
import 'Screens/welcome_screen.dart';

class Chatroomscreen extends StatefulWidget {
  @override
  _ChatroomscreenState createState() => _ChatroomscreenState();
}

class _ChatroomscreenState extends State<Chatroomscreen> {
  @override
  inistate() async {
    constant.myname = (await sharedprefference.getusername())!;
  }

  Widget chatroom(String username) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chatroom')
          .where('users', arrayContains: username)
          .snapshots(),
      builder: (context, snapshot) {
        final count = snapshot.data?.docs.length;
        return ListView.builder(
          shrinkWrap: true,
          itemCount: count,
          itemBuilder: (context, index) {
            return Chatroomtile(
                username:
                    (snapshot.data?.docs[index].data() as dynamic)['chatroomid']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(constant.myname, ""),
            chatroomid:  (snapshot.data?.docs[index].data() as dynamic)['chatroomid'],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    inistate();
    chatroom(constant.myname);
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('⚡️Chat'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return WelcomeScreen();
              }));
            },
            icon: Icon(
              Icons.logout,
              size: 24,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.search),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SearchTile();
            }));
          }),
      body: chatroom(constant.myname),
    );
  }
}

class Chatroomtile extends StatelessWidget {
  String username;
  final String chatroomid;
  Chatroomtile({required this.username,required this.chatroomid});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatScreen(chatroomid: chatroomid);
        }));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(40)),
              child: Text(
                '${username.substring(0, 1).toUpperCase()}',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Text(
              '${username.toUpperCase()}',
              style: TextStyle(
                fontSize: 27.0,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
