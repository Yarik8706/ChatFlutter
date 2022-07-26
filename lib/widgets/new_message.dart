import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  NewMessage(this.chatId);

  final String chatId;

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = new TextEditingController();
  String _enteredMessage = '';

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance.collection('chats/${widget.chatId}/messages').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Отправить сообщения...'),
                onChanged: (value) {
                  setState(() {
                    _enteredMessage = value;
                  });
                },
              )
          ),
          IconButton(
              color: Theme.of(context).primaryColor,
              onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
              icon: Icon(Icons.send)
          )
        ],
      ),
    );
  }
}
