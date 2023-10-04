import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
class PostConfig{
 FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

 Future<void> uploadPost(String description, List<XFile> images, String video) async {
   CollectionReference posts = fireStore.collection('posts');
   List<String> imageUrls = [];
   DateTime dateTime = DateTime.now();
   Timestamp timestamp = Timestamp.fromDate(dateTime);

   for (XFile image in images) {
     String imageName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
     Reference storageRef = firebaseStorage.ref().child('images/$imageName');

     UploadTask uploadTask = storageRef.putFile(File(image.path));
     TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

     String downloadURL = await taskSnapshot.ref.getDownloadURL();
     imageUrls.add(downloadURL);
   }


   posts.add({
     'description': description,
     'images': imageUrls, // Use image URLs instead of local paths
     'video': video,
     'user_id': user!.uid,
     'time': timestamp,
     'likes': [],
   });
 }

 Future<List<DocumentSnapshot>> getPostDoc()async{
      CollectionReference collectionReference = fireStore.collection('posts');
      QuerySnapshot querySnapshot =await collectionReference.orderBy('time', descending: true).get();
      List<DocumentSnapshot> documents = querySnapshot.docs;
      return documents;
  }
   Future<List<DocumentSnapshot>> getPostDocWithId(String userId)async{
      CollectionReference collectionReference = fireStore.collection('posts');
      QuerySnapshot querySnapshot =await collectionReference.where('user_id', isEqualTo: userId).get();
      List<DocumentSnapshot> documents = querySnapshot.docs;
      return documents;
  }
  
}