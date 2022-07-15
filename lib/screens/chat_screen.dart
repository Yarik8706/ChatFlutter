import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Чат'),
          actions: [
            DropdownButton(
                icon: Icon(Icons.more_vert, color: Theme.of(context).primaryIconTheme.color,),
                items: [
                  DropdownMenuItem(
                    value: 'logout',
                      child: Container(
                        child: Row(
                          children: [
                            Icon(Icons.exit_to_app),
                            SizedBox(width: 8),
                            Text('Выйти из аккаунта')
                          ],
                        ),
                  ))
                ],
                onChanged: (itemID) {
                  if(itemID == 'logout') {
                    FirebaseAuth.instance.signOut();
                  }
                }
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chats/KmOUU4hzvvIjE6TSBpSe/messages').snapshots(),
            builder: (context, streamSnapshot) {
              if (streamSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final documents = streamSnapshot.data!.docs;
              return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) =>
                      Container(
                          padding: const EdgeInsets.all(8),
                          child: Text(documents[index]['text'])
                      )
              );
            }
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () =>
            {
              FirebaseFirestore.instance
                  .collection('chats/KmOUU4hzvvIjE6TSBpSe/messages').add({
                'text': 'text clicked'
              })
            }
        )
    );
  }
}
