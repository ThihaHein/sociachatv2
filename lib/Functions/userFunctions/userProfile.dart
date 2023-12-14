import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:sociachatv2/Functions/userFunctions/userEdit.dart';
import 'package:sociachatv2/Functions/userFunctions/userProfilePost.dart';
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
                                    kBlack.withOpacity(0.6),
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
                    UserProfilePost(),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
