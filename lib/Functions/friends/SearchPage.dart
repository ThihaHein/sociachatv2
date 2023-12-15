import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sociachatv2/Functions/friends/userProfile.dart';
import 'package:sociachatv2/designs/resources/style.dart';
import 'package:sociachatv2/models/search/searchConfig.dart';

import '../../models/users/userConfig.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController searchKey = TextEditingController();
  Future<List<DocumentSnapshot>>? searchUserResults;
  User? user = FirebaseAuth.instance.currentUser;
  bool followingExist= false;
  List<String> followingUserList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchFollowingList();
  }
  Future<void> fetchFollowingList() async{
      List<String> followingIds = await UserConfig().getFollowingList(user!.uid);
      setState(() {
        followingUserList = followingIds;
      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20,),
              child: Column(
                children: [
                Form(
                    key: _formKey,
                    child: Container(
                      padding: EdgeInsets.only(left: 20, top: 0.6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: kDarkGrey.withOpacity(0.4),
                      ),
                      child: TextFormField(
                      controller: searchKey,
                       style: TextStyle(color: kWhite),
                       decoration: InputDecoration(
                         suffixIcon: Icon(Icons.search, color: kWhite.withOpacity(0.3),),
                         hintText: "Search Post or Friend..",
                         border: InputBorder.none,
                         hintStyle: kNanumGothicSemiBold.copyWith(color: kWhite.withOpacity(0.4), fontSize: 15),
                       ),
                        onChanged: (value) {
                          setState(() {
                            searchUserResults = SearchConfig().searchUser(value);
                          });
                        },
                ),
                    )),
                  SizedBox(height: 20,),
                  if(searchKey.text.isNotEmpty)
                  FutureBuilder(
                    future: searchUserResults,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator(color: kGrey, backgroundColor: kDarkGrey,));
                      } else if (snapshot.hasError) {
                        return Text('Error');
                      } else {
                        List<DocumentSnapshot>? documents = snapshot.data;
                          if (documents == null || documents.isEmpty) {
                            return Text('No results found.',
                              style: kNanumGothicSemiBold.copyWith(
                                  color: kWhite.withOpacity(0.5)),);
                          }
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: documents.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            DocumentSnapshot document = documents[index];
                            Map<String, dynamic>? users = document.data() as Map<String, dynamic>?;
                            String username = users?['username'];
                            String userId = users?['user_id'];
                            bool isUser = false;
                            if(userId==user!.uid){
                              isUser = true;
                            }
                           bool isFollowing = followingUserList.contains(userId);
                           print(userId);
                           print(isFollowing);
                           print(followingUserList);
                            return Container(
                              margin:  EdgeInsets.all(10),
                              child: Column(
                                children: [
                                 Container(
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                       Text('$username', style: kNanumGothicBold.copyWith(color: kWhite),),
                                       if(isFollowing)
                                       ElevatedButton(
                                           onPressed: (){
                                             Navigator.push(context, MaterialPageRoute(builder: (context)=>UserProfile(userId: userId,)));
                                           },
                                           child: Text('View Profile')),
                                       ElevatedButton(
                                           onPressed: (){
                                            UserConfig().requestFollow(userId, user!.uid);
                                             },style: ElevatedButton.styleFrom(backgroundColor: isUser || isFollowing ? Colors.transparent:kBlue,side: isUser || isFollowing?BorderSide(color: kDarkGrey):null), child: Text(isUser? 'My Account':isFollowing? 'Following': "Follow", style: kanumGothicRegular.copyWith(color: kWhite),))
                                     ],
                                   ),
                                 )
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {

    searchKey.dispose();
    super.dispose();
  }
}
