import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SearchConfig{
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  Future<List<DocumentSnapshot>> searchUser(String query) async{
   CollectionReference collectionReference = fireStore.collection('users');
   QuerySnapshot querySnapshot = await collectionReference
        .where('username', isGreaterThanOrEqualTo: query)
        .where('username', isLessThan: query+'z').get();
   List<DocumentSnapshot> documents = querySnapshot.docs;
    return documents;
  }
  Future<List<DocumentSnapshot>> searchPost(String query) async{
    CollectionReference collectionReference= fireStore.collection('posts');
    QuerySnapshot querySnapshot = await collectionReference
        .where('description', isGreaterThanOrEqualTo: query)
        .where('description', isLessThan: query + 'z').get();
    List<DocumentSnapshot> documents = querySnapshot.docs;
    return documents;
  }
}