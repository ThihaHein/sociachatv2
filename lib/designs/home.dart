import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:sociachatv2/Functions/post/postList.dart';
import 'package:sociachatv2/database/auth.dart';
import 'package:sociachatv2/designs/resources/style.dart';
import 'package:sociachatv2/models/posts/postConfig.dart';
import 'dart:ui' as ui;

import 'package:sociachatv2/test/test.dart';
import 'package:sociachatv2/models/users/userConfig.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  String username ='';

  Future<void> getUsername() async {
    String result = await UserConfig().getUserName(user!.uid);
    setState(() {
      username = result;
    });
  }
@override
void initState()  {
    // TODO: implement initState
  getUsername();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children:[
            Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Welcome, $username", style: kNanumGothicBold.copyWith(color: kWhite, fontSize: 16),),
                    GestureDetector(
                      onTap: (){
                        Auth().signOut();
                        Auth().signOutFromGoogle();
                      },
                      child: Container(
                        width: 33,
                        height: 33,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: kWhite, width: 0.6)
                        ),
                        child: Stack(children: [
                          Center(child: Icon(Icons.mail_outline,color: kWhite,size: 20,)),
                          Positioned(
                            top: 6.5,
                            right: 5,
                            child: Container(

                              width: 7.5,
                              height: 7.5,
                              decoration: BoxDecoration(
                                border: Border.all(color: kWhite),
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ]),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10,right: 0,top:40),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child:Row(

                    children: [
                     Padding(
                       padding: const EdgeInsets.only(right: 10.0),
                       child: Stack(
                         children: [
                            Positioned(
                              child: SizedBox(
                                height: 150,
                                width: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(kBorderRadius),
                                  child: Stack(children: [
                                    Image.network("https://www.brides.com/thmb/QYAH2f-QYv6VINzv2KZvpeKdcJs=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/FT-73-d62bdf370c7c415195b73f935924a632.jpg",fit: BoxFit.cover,),
                                    Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
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

                                  ]),
                                ),
                              ),
                            ),
                           Positioned(
                             bottom: 5,
                             right: 30,
                             child: Container(
                               decoration: BoxDecoration(
                                   color: Colors.transparent,
                                   borderRadius: BorderRadius.circular(30),
                                   border: GradientBoxBorder(gradient: LinearGradient(
                                       begin: Alignment.centerLeft,
                                       end: Alignment.centerRight,
                                       colors: [kPink, kPurple]
                                   ), width: 3)
                               ),
                               child: Container(
                                 decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(30),
                                     border: Border.all(color: Colors.transparent, width: 1.5)
                                 ),
                                 child: SizedBox(
                                   height: 35,
                                   width: 35,
                                    child: ClipRRect(
                                      child: Image.network("https://images.pexels.com/photos/1674752/pexels-photo-1674752.jpeg?cs=srgb&dl=pexels-tony-jamesandersson-1674752.jpg&fm=jpg",fit: BoxFit.cover,),
                                     borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                               ),
                             ),
                           ),

                         ],
                       ),
                     ),
                    ],
                  ),

                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: PostList(),
              )
            ],
          ),

        ]
        ),
      ),
    );
  }
}
