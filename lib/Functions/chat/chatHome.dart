import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sociachatv2/models/chat/chatConfig.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              FutureBuilder(
                  future: ChatConfig().getChatList(user!.uid),
                  builder: (context, snapshot){
                    if(snapshot.connectionState==ConnectionState.waiting){
                      return Center(child: Text('Loading Data'),);
                    }else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }else{
                      final chatList = snapshot.data;
                      return ListView.builder(
                        itemCount: chatList!.length,
                          itemBuilder: (context, index){
                        final chats = chatList[index];
                        String chatId = chats['chat_id'];
                        String anotherUserId = chats['another_user_id'];
                  // I STOPPED AT ADDIN ANOTHER USER ID TO GET ANOTHER USER DATA AND SHOW IT

                      });
                    }
                  })
            ],
          ),
        ));
  }
}
