import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatConfig{

  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

  Future<void> createPrivateChat(List<String> userIds, String userId)async {
    CollectionReference collectionReference = firebaseFireStore.collection('chat');
    DocumentReference documentReference = collectionReference.doc();
    CollectionReference chatUserCollectionReference = documentReference.collection('userIds');
    for(String userId in userIds){
      chatUserCollectionReference.doc(userId).set({
        'user_id': userId
      });
    }
    String anotherUserId = userIds.first;
    DocumentReference userReference = firebaseFireStore.collection('users').doc(userId);
    CollectionReference userCollectionReference = userReference.collection('chatIds');
    userCollectionReference.add({
      'chat_id': documentReference.id,
      'another_user_id': anotherUserId
    });
  }
  Future<void> sendMessage(String chatId,String text, String senderId) async{
    CollectionReference collectionReference = firebaseFireStore.collection('chat').doc(chatId).collection('messages');
    DateTime dateTime = DateTime.now();
    await collectionReference.add({
      'message': text,
      'sender_Id': senderId,
      'sent_time': dateTime,
    });
  }
  Future<List<DocumentSnapshot>> getMessages(String chatId) async{
    CollectionReference collectionReference = firebaseFireStore.collection('chat').doc(chatId).collection('messages');
    QuerySnapshot querySnapshot = await collectionReference.get();
    List<DocumentSnapshot> documents = querySnapshot.docs;
    return documents;
  }
  Future<String?> checkChatExist(List<String> userIds) async{
    CollectionReference collectionReference = firebaseFireStore.collection('chat');

    QuerySnapshot querySnapshot = await collectionReference.doc().collection('userIds').where('user_id', isEqualTo: userIds).get();
    if (querySnapshot.docs.isNotEmpty) {
      print(querySnapshot.docs[0].id);
      return querySnapshot.docs[0].id;
    }
      return null;
  }
  Future<String?> checkChatExistForUser(String userId) async{
    CollectionReference collectionReference = firebaseFireStore.collection('chat');

    QuerySnapshot querySnapshot = await collectionReference.where('userIds', arrayContains: userId).get();
    if (querySnapshot.docs.isNotEmpty) {
      print(querySnapshot.docs[0].id);
      return querySnapshot.docs[0].id;
    }
      return null;
  }
  Stream<QuerySnapshot> getMessageStream(String chatId) {
    CollectionReference collectionReference = firebaseFireStore.collection('chat').doc(chatId).collection('messages');
    return collectionReference.orderBy('sent_time',descending: true).snapshots();
  }
  Future<List<DocumentSnapshot>> getChatList(String userId)async{
    CollectionReference collectionReference = firebaseFireStore.collection('users').doc(userId).collection('chat_id');
    QuerySnapshot querySnapshot = await collectionReference.get();
    List<DocumentSnapshot> documents = querySnapshot.docs;
    return documents;
  }
}
