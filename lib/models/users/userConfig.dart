import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class UserConfig{
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<void> addUser(String userId, String username, String email) async {
    await fireStore.collection('users').doc(userId).set({
      'email': email,
      'username': username,
      'user_id': userId,
    });
  }
  Stream<QuerySnapshot> getUsersStream() {
    CollectionReference users = fireStore.collection('users');
    return users.snapshots();
  }
  Future<String> getUserName(String userId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').where('user_id', isEqualTo: userId).get();
      return snapshot.docs.first.get('username');
  }
  Future<String> getUserPhoto(String userId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').where('user_id', isEqualTo: userId).get();
      return snapshot.docs.first.get('username');
  }
  Future<bool> checkIfEmailExists(String? email) async {
    final QuerySnapshot snapshot = await fireStore.collection('users').where('email', isEqualTo: email).get();
    return snapshot.docs.isNotEmpty;
  }

  Future<void> createUserRecord(User user) async {
    await fireStore.collection('users').doc(user.uid).set({
      'email': user.email,
      'username': user.displayName,
      'user_id': user.uid,
    });
  }
  Future<void> requestFollow(String userId, String followingUserId)async{
      DocumentReference followingDocumentReference = fireStore.collection('users').doc(followingUserId);
      CollectionReference followingCollectionReference = followingDocumentReference.collection('following_id');
      await followingCollectionReference.add({
        'following_user_id': userId,
      });
      DocumentReference followerDocumentReference = fireStore.collection('users').doc(userId);
      CollectionReference followerCollectionReference = followerDocumentReference.collection('follower_id');
      await followerCollectionReference.add({
        'follower_user_id': followingUserId,
      });
  }
  Future<List<String>> getFollowingList(String userId) async {
    DocumentReference documentReference = fireStore.collection('users').doc(userId);
    CollectionReference collectionReference = documentReference.collection('following_id');
    QuerySnapshot querySnapshot = await collectionReference.get();

    List<String> followingUserIds = [];

    querySnapshot.docs.forEach((document) {
      String followingUserId = document.get('following_user_id');
      followingUserIds.add(followingUserId);
    });

    return followingUserIds;
  }Future<List<String>> getFollowerList(String userId) async {
    DocumentReference documentReference = fireStore.collection('users').doc(userId);
    CollectionReference collectionReference = documentReference.collection('follower_id');
    QuerySnapshot querySnapshot = await collectionReference.get();

    List<String> followerUserIds = [];

    querySnapshot.docs.forEach((document) {
      String followerUserId = document.get('follower_user_id');
      followerUserIds.add(followerUserId);
    });

    return followerUserIds;
  }

}