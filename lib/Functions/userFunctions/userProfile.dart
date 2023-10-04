import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:sociachatv2/Functions/userFunctions/userEdit.dart';
import 'package:sociachatv2/database/auth.dart';
import 'package:sociachatv2/models/posts/postConfig.dart';

import '../../designs/resources/style.dart';
import '../../models/users/userConfig.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  User? user = FirebaseAuth.instance.currentUser;
 String username = '';
  List<String> followingUserList = [];
  List<String> followerUserList = [];

  Future<void> fetchFollowingList() async{
    List<String> followingIds = await UserConfig().getFollowingList(user!.uid);
    setState(() {
      followingUserList = followingIds;
    });
  }
  Future<void> fetchFollowerList() async{
    List<String> followerIds = await UserConfig().getFollowerList(user!.uid);
    setState(() {
      followerUserList = followerIds;
    });
  }
  Future<void> getUsername() async {
    String result = await UserConfig().getUserName(user!.uid);
    setState(() {
      username = result;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    getUsername();
    fetchFollowingList();
    fetchFollowerList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
          backgroundColor: kBgColor,
          body: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Container(
                width: double.infinity,
                height: 230,
                child: Stack(

                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 160,
                      decoration: BoxDecoration(
                          color: kBgColor,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Stack(
                          children:[
                            Container(
                              width:double.infinity,
                              decoration: BoxDecoration(
                                  color: kBgColor,
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                                child: Image.network("https://i.pinimg.com/564x/67/05/08/6705086df60e7d987767b8fd10a2dfa2.jpg", fit: BoxFit.cover,),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.6),
                                  ],
                                ),
                              ),
                            ),
                          ]
                      ),
                    ),
                    Positioned.fill(
                      bottom: -80,

                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(100),
                              border: GradientBoxBorder(gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [kPink, kPurple]
                              ), width: 2 )
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(color: Colors.transparent, width: 2)
                            ),
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: ClipRRect(
                                child: Image.network(user!.photoURL!,fit: BoxFit.cover,),
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0,left: 10,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('$username', style: kNanumGothicBold.copyWith(color: kWhite,fontSize: 18),),
                    SizedBox(height: 20,),
                    Text('Writer by Profession. Artist by Passion!', style: kNanumGothicMedium.copyWith(color: kWhite,fontSize: 14),),
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${followerUserList.length}',style: kNanumGothicBold.copyWith(color: kWhite, fontSize: 14),),
                              SizedBox(height: 5,),
                              Text('Followers',style: kNanumGothicBold.copyWith(color: kDarkGrey, fontSize: 14),),
                            ],
                          ),

                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${followingUserList.length}',style: kNanumGothicBold.copyWith(color: kWhite, fontSize: 14),),
                              SizedBox(height: 5,),
                              Text('Following',style: kNanumGothicBold.copyWith(color: kDarkGrey, fontSize: 14),),
                            ],
                          ),

                        ElevatedButton(
                        style: ElevatedButton.styleFrom(side: BorderSide(color: kGrey, width: 1.5,), backgroundColor: Colors.transparent, shape: StadiumBorder()),
                          onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>EditUserPage()));
                          },
                          child: Text('Edit Profile')),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Posts', style: kNanumGothicSemiBold.copyWith(color: kWhite),),
                          Text('Stories', style: kNanumGothicSemiBold.copyWith(color: kWhite),),
                          Text('Liked', style: kNanumGothicSemiBold.copyWith(color: kWhite),),
                          Text('Tagged', style: kNanumGothicSemiBold.copyWith(color: kWhite),),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0,left: 30,right: 30),
                      child: Divider(thickness: 0.5,color: kDarkGrey,),
                    ),
                    FutureBuilder(
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
                        }),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
