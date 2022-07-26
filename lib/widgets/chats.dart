import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/chat_screen.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {

  @override
  void initState() {
    // TODO: implement initState
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chats').snapshots(),
        builder: (context, chatsSnapshot) {
          if(chatsSnapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          print(chatsSnapshot.data!.size);
          var chatsDocs = chatsSnapshot.data!.docs;
          return ListView.builder(
            itemCount: chatsDocs.length,
            itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(chatsDocs[index]['title'], chatsDocs[index].id),
                      ),
                    );
                  },
                  child: Card(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          chatsDocs[index]['title'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20
                          ),
                        )
                      ],
                    ),
                  ),
                );
            },
          );
        });
  }
}
