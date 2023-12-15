import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sociachatv2/designs/resources/style.dart';
import 'package:sociachatv2/models/chat/chatConfig.dart';

class ChatPage extends StatefulWidget {
  final chatId;
  const ChatPage({super.key, this.chatId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBgColor,
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: ChatConfig().getMessageStream(widget.chatId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Text('Loading messages...'),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    List<QueryDocumentSnapshot> messages = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        QueryDocumentSnapshot document = messages[index];
                        String message = document['message'];
                        String senderId = document['sender_Id'];
                        if (message.isEmpty) {
                          return SizedBox.shrink();
                        } else {
                          if (senderId != user!.uid) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                color: Colors.transparent,
                                child: Text(message),
                              ),
                            );
                          }
                          return Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  color: kPurple,
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Text(message),
                            ),
                          );
                        }
                      },
                    );
                  }
                },
              ),
            ),
            _buildInputField(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: TextStyle(color: kWhite),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              ChatConfig().sendMessage(widget.chatId, _messageController.text, user!.uid);
              _messageController.clear();
            },
          ),
        ],
      ),
    );
  }
}
