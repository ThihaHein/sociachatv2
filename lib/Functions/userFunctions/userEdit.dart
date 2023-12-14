import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sociachatv2/Functions/userFunctions/userProfile.dart';
import 'package:sociachatv2/designs/resources/style.dart';

class EditUserPage extends StatefulWidget {

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  User? user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: kBgColor,
          body: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Container(
                height: 60,
                color: kBgColor,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent,elevation: 0,foregroundColor: Colors.transparent),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios_new, color: kGrey,),
                    label: Text('Back To Profile', style: kanumGothicRegular.copyWith(color: kGrey),)),
              ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(user!.photoURL!, fit: BoxFit.cover,),
                        ),
                      ),
                      Form(
                        key: _formKey,
                          child: Column(
                            children: [

                            ],
                          ))
                    ],
                  )
                ],
              ),
            )
            ],
          ),
        ));
  }
}
