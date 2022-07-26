import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/chats.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Чаты'),
        actions: [
          DropdownButton(
              icon: Icon(Icons.more_vert, color: Theme.of(context).primaryIconTheme.color,),
              items: [
                DropdownMenuItem(
                    value: 'logout',
                    child: Row(
                      children: const [
                        Icon(Icons.exit_to_app),
                        SizedBox(width: 8),
                        Text('Выйти из аккаунта')
                      ],
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
      body: Chats(),
    );
  }
}
