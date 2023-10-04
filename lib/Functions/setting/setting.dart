import 'package:flutter/material.dart';
import 'package:sociachatv2/designs/resources/style.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: kBgColor,
          body: ListView(
            children: [
              Container(
                child:
                Column(
                  children: [
                    
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
