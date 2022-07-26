import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/message_bubble.dart';

class Messages extends StatelessWidget {
  Messages(this.chatId);

  final String chatId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('chats/$chatId/messages').orderBy(
          'createdAt',
          descending: true
      ).snapshots(),
      builder: (context, chatSnapshot) {
        if(chatSnapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator(),);
        }

        if(chatSnapshot.data!.size == 0) {
          return const Center(
              child: Text('Здесь пока ничего нет!', style: TextStyle(fontSize: 20)
              )
          );
        }

        final chatDocs = chatSnapshot.data!.docs;
        return ListView.builder(
            reverse: true,
            itemCount: chatDocs.length,
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.only(top: 10),
              child: MessageBubble(
                chatDocs[index]['text'],
                chatDocs[index]['userId'] == FirebaseAuth.instance.currentUser!.uid,
                chatDocs[index]['userId']
              ),
            ),
        );
      },
    );
  }
}
