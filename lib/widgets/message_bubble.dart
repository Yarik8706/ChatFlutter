import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.message, this.isThisUser, this.userId);

  final String userId;
  final String message;
  final bool isThisUser;

  @override
  Widget build(BuildContext context) {
    final messageWidth = MediaQuery.of(context).size.width / 1.5;
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
        children: [
          Row(
            mainAxisAlignment: isThisUser
                ? MainAxisAlignment.end
                : MainAxisAlignment
                .start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: isThisUser ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: isThisUser ? const Radius.circular(12) : const Radius.circular(0),
                      topLeft: isThisUser ? const Radius.circular(12) : const Radius.circular(0),
                      bottomRight: !isThisUser ? const Radius.circular(12) : const Radius.circular(0),
                      topRight: !isThisUser ? const Radius.circular(12) : const Radius.circular(0),
                    ),
                    border: Border.all(
                        color: Theme.of(context).primaryColor,
                        style: BorderStyle.solid,
                        width: 2.0
                    )
                ),
                width: messageWidth,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                      builder: (context, userSnapshot) {
                        String text;
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          text = 'Loading...';
                        } else {
                          text = userSnapshot.data!['username'];
                        }

                        return Text(text,
                            style: TextStyle(fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isThisUser
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).primaryColorLight
                            )
                        );
                      },
                    ),
                    Text(message,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 18,
                          color: isThisUser
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).primaryColorLight,
                        )
                    ),
                  ],
                ),
              ),
            ],
          ),
          Transform.translate(
            offset: isThisUser
                ? Offset(screenWidth - messageWidth - 40, -10)
                : Offset(screenWidth - (screenWidth - messageWidth) - 40, -10),
            child: CircleAvatar(
              radius: 25.00,
              backgroundColor: Theme.of(context).primaryColor,
               child: FutureBuilder<DocumentSnapshot>(
                 future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                 builder: (context, userSnapshot) {
                   if (userSnapshot.connectionState !=
                       ConnectionState.waiting) {
                     return CircleAvatar(
                       child: ClipRRect(
                         borderRadius: BorderRadius.circular(50),
                         child: Image.memory(base64Decode(userSnapshot.data!['image']), fit: BoxFit.cover, width: 40, height: 40,),
                       ),
                     );
                   }
                   return Container();
                   },
               ),
            )
          )
        ]
    );
  }
}
