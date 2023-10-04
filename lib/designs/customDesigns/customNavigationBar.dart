import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sociachatv2/Functions/friends/SearchPage.dart';
import 'package:sociachatv2/Functions/post/postUpload.dart';
import 'package:sociachatv2/Functions/userFunctions/userProfile.dart';
import 'package:sociachatv2/designs/home.dart';
import 'package:sociachatv2/designs/resources/style.dart';

class CustomNavigationBar extends StatefulWidget {

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar>  with AutomaticKeepAliveClientMixin{
  var _currentIndex = 0;
  final List<Widget> _children = [
  HomePage(),
  SearchPage(),
  PostUpload(),
  HomePage(),
  UserProfile(),
  ];

  void onTapped(index){
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PageStorage(
      bucket: PageStorageBucket(),
      child: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar:  Container(
          decoration: BoxDecoration(
            color: kBlack,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          child: GNav(
              selectedIndex: _currentIndex,
              onTabChange: onTapped,
              activeColor: kWhite,
              tabBackgroundColor: Colors.transparent,
              backgroundColor: kBlack,
              color: kGrey,
              padding: const EdgeInsets.all(1),
              tabs:  [
               GButton(
                 icon: Icons.home_filled,
               ),GButton(
                 icon: Icons.search,
               ),GButton(
                 icon: Icons.add_circle_rounded,
                 iconSize: 35,
                  iconColor: kPink,

               ),GButton(
                 icon: Icons.notifications_none,
               ),GButton(
                 icon: Icons.person_outlined,
               ),
              ]),
        ),
    )
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
