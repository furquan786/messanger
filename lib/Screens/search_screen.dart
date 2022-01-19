import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat/Screens/chat_screen.dart';
import 'package:flashchat/Screens/welcome_screen.dart';
import 'package:flashchat/contstant.dart';
import 'package:flashchat/sharedprefferences.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchTile extends StatefulWidget {
  const SearchTile({Key? key}) : super(key: key);

  @override
  _SearchTileState createState() => _SearchTileState();
}

class _SearchTileState extends State<SearchTile> {
  TextEditingController textEditingController = new TextEditingController();
  late QuerySnapshot searchResultSnapshot;
  bool haveUserSearched = false;
  late Stream chatroomstream;

  cratechatroom(String chatroomid, chatroommap) {
    FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatroomid)
        .set(chatroommap)
        .catchError((e) {
      print(e);
    });
  }

  createconversationroom(String username) {
    if (constant.myname != username) {
      String _chatroomid = getChatRoomId(username, constant.myname);
      List<String> user = [username, constant.myname];
      Map<String, dynamic> _chatroommap = {
        'users': user,
        'chatroomid': _chatroomid,
      };
      cratechatroom(_chatroomid, _chatroommap);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return ChatScreen(
              chatroomid: _chatroomid,
            );
          },
        ),
      );
    } else {
      print('this is not valid user');
    }
  }

  searchByName(String searchField) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where('username', isEqualTo: searchField)
        .get();
  }

  initiatestate() async {
    if (textEditingController.text.isNotEmpty) {
      await searchByName(textEditingController.text).then((snapshot) {
        searchResultSnapshot = snapshot;
        print('$searchResultSnapshot');
        setState(() {
          haveUserSearched = true;
        });
      });
    }
  }

  Widget userList() {
    return haveUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResultSnapshot.docs.length,
            itemBuilder: (context, index) {
              return userTile(
                (searchResultSnapshot.docs[index].data()
                    as dynamic)['username'],
                // (searchResultSnapshot.docs[index].data as dynamic )[""],
              );
            })
        : Container();
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  gettingid() async {
    constant.myname = (await sharedprefference.getusername())!;
  }



  // getuserchats(String username) async {
  //   return await FirebaseFirestore.instance
  //       .collection('chatroom')
  //       .where('users', arrayContains: username)
  //       .snapshots();
  // }

  @override
  void initState() {
    gettingid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text('⚡️Chat'),
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
        backgroundColor: Colors.grey,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.grey,
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      cursorColor: Colors.pinkAccent,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: 'Search User Name...',
                        hintStyle: TextStyle(
                          color: Colors.white38,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await initiatestate();
                      textEditingController.clear();
                      print('i am on');
                    },
                    icon: Icon(
                      Icons.search_outlined,
                      size: 50.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: userList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget userTile(String userName) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              // Text(
              //   userEmail,
              //   style: TextStyle(
              //       color: Colors.white,
              //       fontSize: 16
              //   ),
              // )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createconversationroom(userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(24)),
              child: Text(
                "Message",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }
}

