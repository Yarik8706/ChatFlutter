import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/messages.dart';
import 'package:flutter_chat/widgets/new_message.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen(this.title, this.chatId);

  final String chatId;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title)
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                  child: Messages(chatId)
              ),
              NewMessage(chatId)
            ],
          ),
        )
    );
  }
}
