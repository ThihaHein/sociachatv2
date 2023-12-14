import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../designs/resources/style.dart';
import '../../models/posts/postConfig.dart';
import '../../models/users/userConfig.dart';

class UserProfilePost extends StatefulWidget {

  @override
  State<UserProfilePost> createState() => _UserProfilePostState();
}

class _UserProfilePostState extends State<UserProfilePost> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
        future: PostConfig().getPostDocWithId(user!.uid),
        builder: (context, snapshot){
          if(snapshot.connectionState== ConnectionState.waiting){
            return CircularProgressIndicator();
          }
          else if(snapshot.data!.isEmpty){
            return Center(
              child: Text('No Post yet!', style: kNanumGothicSemiBold.copyWith(color: kWhite),),
            );
          }
          else{
            List<DocumentSnapshot> documents = snapshot.data!;
            return ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: documents.length,
                itemBuilder: (context, index){
                  DocumentSnapshot document = documents[index];
                  Map<String, dynamic>? post = document.data() as Map<String, dynamic>?;
                  List<dynamic> imageUrls = post?['images'];
                  String userId = post?['user_id'];
                  Timestamp timeString = post?['time'];
                  print(timeString);
                  DateTime time = timeString.toDate();
                  print(time);
                  Duration timeDiff = DateTime.now().difference(time);
                  String timeDiffString = '';
                  int months = timeDiff.inDays ~/ 30;
                  if(months>0){
                    if(months==1){
                      timeDiffString = '$months month ago';
                    }
                    else {
                      timeDiffString = '$months months ago';
                    }
                  }
                  else if(timeDiff.inDays>0){
                    timeDiffString = '${timeDiff.inDays} days ago';
                  }else if(timeDiff.inHours>0){
                    timeDiffString = '${timeDiff.inHours}h ago';
                  }else if(timeDiff.inMinutes>0){
                    timeDiffString = '${timeDiff.inMinutes}m ago';
                  }else{
                    timeDiffString = 'Just now';
                  }
                  return Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: kWhite,
                                    borderRadius: BorderRadius.circular(20)
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder(
                                  future: UserConfig().getUserName(userId),
                                  builder: (context,  snapshot) {
                                    if(snapshot.connectionState== ConnectionState.waiting){
                                      return Container();
                                    }
                                    else if (snapshot.hasError){
                                      return Text('Login',style: kNanumGothicMedium.copyWith(color: kWhite));
                                    }
                                    else {
                                      String username = snapshot.data!;
                                      return Text('$username',style: kNanumGothicMedium.copyWith(color: kWhite),);
                                    }
                                  },),

                                SizedBox(height: 5,),
                                Text('$timeDiffString',style: kNanumGothicMedium.copyWith(color: kDarkGrey),)
                              ],
                            ),
                            Spacer(),
                            GestureDetector(
                              child: Icon(Icons.more_vert, color: kDarkGrey ,),
                            )
                          ],
                        ),
                        SizedBox(height: 30),
                        Text("${post?['description']}",style: kNanumGothicMedium.copyWith(color: kWhite,fontSize: 16),),
                        SizedBox(height: 10,),
                        if(imageUrls.isNotEmpty)
                          Container(
                            height: 300,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              itemCount: imageUrls.length,
                              shrinkWrap: true,
                              itemBuilder: (context, imgIndex) {
                                String imageUrl = imageUrls[imgIndex];

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: (){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.transparent,
                                            content: Container(
                                              width: MediaQuery.of(context).size.width,
                                              height: MediaQuery.of(context).size.height * 0.6,
                                              child: Hero(
                                                tag: 'image_$index',
                                                child: Image.network(imageUrl,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(imageUrl, fit: BoxFit.cover,)),
                                  ),
                                );
                              },
                            ),
                          ),
                        Container(
                          margin: EdgeInsets.only(top: 20,bottom: 10),
                          child: Row(
                            children: [
                              GestureDetector(
                                  onTap: (){
                                  },
                                  child: Icon(  Icons.thumb_up_alt_outlined,color: kWhite,size: 20,)),
                              SizedBox(width: 35),
                              Icon(Icons.mode_comment_outlined,color: kWhite,size: 20),
                              SizedBox(width: 35),
                              Icon(Icons.ios_share_outlined,color: kWhite,size: 20),
                              Spacer(),
                              Icon(Icons.bookmark_outline,color: kWhite,size: 20),
                            ],
                          ),
                        ),
                        Divider(thickness: 0.5,color: kDarkGrey,)
                      ],
                    ),
                  );
                });
          }
        });
  }
}
