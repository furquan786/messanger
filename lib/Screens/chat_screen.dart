import 'package:flutter/material.dart';
import 'package:flashchat/contstant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

late User loggedinuser;

class ChatScreen extends StatefulWidget {
  final String chatroomid;
  ChatScreen({required this.chatroomid});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _controller = new ScrollController();
  final textController = new TextEditingController();
  late String email;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late String messagetext;
  late String usser;
  @override
  void initState() {
    super.initState();
    getcurrentuser();
    getuserinfo();
  }

  getuserinfo() async {}

  void getcurrentuser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedinuser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  // void getmessage()async{
  //  final messages =await _firestore.collection('messages').get();
  //  for(var _messages in messages.docs){
  //    print(_messages.data());
  //  }
  // }

  // void messagestream() async {
  //   await for (var stream in _firestore.collection('users').snapshots()) {
  //     for (var _messages in stream.docs) {
  //       print(_messages.data());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "images/back.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: null,
            centerTitle: true,
            title: Text('⚡️Chat'),
            backgroundColor: Colors.grey[850],
          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('chatroom')
                      .doc(widget.chatroomid)
                      .collection('chats')
                      .orderBy('time')
                      .snapshots(),
                  builder: (context, snapshot) {
                    List<MessageBubbbles> messageswidgets = [];
                    if (snapshot.hasData) {
                      final _messages = snapshot.data!.docs.reversed;
                      for (var mess in _messages) {
                        final messagestext =
                            (mess.data() as dynamic)['messages'];
                        final messagesender =
                            (mess.data() as dynamic)['sender'];
                        // final time = (mess.data() as dynamic)['time'];
                        final currentuser = loggedinuser.email;
                        final messagewidget = MessageBubbbles(
                          text: messagestext,
                          sender: messagesender,
                          // timer: time,
                          isme: currentuser == messagesender,
                        );

                        messageswidgets.add(messagewidget);
                      }
                    }
                    return Expanded(
                      child: Scrollbar(
                        interactive: true,
                        controller: _controller,
                        isAlwaysShown: true,
                        showTrackOnHover: false,
                        thickness: 8.0,
                        radius: Radius.circular(12.0),
                        child: ListView(
                          reverse: true,
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 12.0),
                          controller: _controller,
                          children: messageswidgets,
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  decoration: kMessageContainerDecoration,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          cursorColor: Colors.black,
                          controller: textController,
                          onChanged: (value) {
                            messagetext = value;
                          },
                          decoration: kMessageTextFieldDecoration,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 5),
                        margin: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blueGrey,
                        ),
                        child: IconButton(
                            onPressed: () {
                              textController.clear();
                              _firestore
                                  .collection('chatroom')
                                  .doc(widget.chatroomid)
                                  .collection('chats')
                                  .add(
                                {
                                  'messages': messagetext,
                                  'sender': loggedinuser.email,
                                  'time': DateTime.now().millisecondsSinceEpoch
                                  // 'user':usser,/
                                },
                              );
                            },
                            icon: Icon(
                              Icons.send,
                              color: Colors.white,
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MessageBubbbles extends StatelessWidget {
  MessageBubbbles(
      {required this.text,
      required this.sender,
      required this.isme,
      });

  late final String text;
  late final String sender;
  late bool isme;
  // late final int timer;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '$sender',
            style: isme
                ? TextStyle(color: Colors.white, fontSize: 12.0)
                : TextStyle(color: Colors.white, fontSize: 12.0),
          ),
          // Text(
          //   '$timer',
          //   style: isme
          //       ? TextStyle(color: Colors.white, fontSize: 12.0)
          //       : TextStyle(color: Colors.white, fontSize: 12.0),
          // ),
          Material(
            elevation: 4.0,
            shadowColor: Colors.black12,
            borderOnForeground: true,
            borderRadius: isme
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(32.0),
                    topLeft: Radius.circular(32.0),
                    bottomRight: Radius.circular(32.0))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0),
                    bottomRight: Radius.circular(32.0)),
            color: isme ? Colors.green : Colors.blueGrey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                '$text',
                style: TextStyle(
                  color: isme ? Colors.white : Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
