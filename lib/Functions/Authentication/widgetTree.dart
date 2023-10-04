import 'package:flutter/material.dart';
import 'package:sociachatv2/Functions/Authentication/login.dart';
import 'package:sociachatv2/designs/customDesigns/customNavigationBar.dart';
import 'package:sociachatv2/designs/home.dart';

import '../../database/auth.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChange,
        builder: (context, snapshot){
        if (snapshot.hasData){
          return CustomNavigationBar();
        }
        else{
          return LoginPage();
        }
        });
  }
}
