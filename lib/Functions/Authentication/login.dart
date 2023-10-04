import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:sociachatv2/database/auth.dart';
import 'package:sociachatv2/designs/resources/sizeConfig.dart';
import 'package:sociachatv2/designs/resources/style.dart';

class LoginPage extends StatefulWidget {

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
String? errorMessage = '';
bool isLogin = true;
bool showPassword = true;
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final TextEditingController _usernameController = TextEditingController();
final User? user = Auth().currentUser;
final _formKey = GlobalKey<FormState>();

Future<void> signInWithEmail()async{
  try{
    await Auth().signInWithEmail(_emailController.text, _passwordController.text);
  }on FirebaseAuthException catch (e){
  print(e);
  }
}
Future<void> createUserWithEmail()async{
  try{
    await Auth().createUserWithEmail(_emailController.text,_usernameController.text, _passwordController.text);
  }on FirebaseAuthException catch (e){
  print(e);
  }
}
  Future<void> signOut()async{
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.only(left: 20,right: 20,bottom: 20),
           child: Align(
             child: SingleChildScrollView(
               physics: BouncingScrollPhysics(),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   Text("Welcome", style: GoogleFonts.lobster(color: kWhite,fontSize: 50),),
                   SizedBox(height: 20,),
                   Form(
                     key: _formKey,
                     child: Column(
                       children: [
                           Container(
                             decoration: BoxDecoration(
                                 color: Colors.transparent,
                                 borderRadius: BorderRadius.circular(18.0),
                                 border: const GradientBoxBorder(gradient: LinearGradient(colors: [kPink, kPurple]))

                             ),
                             child: TextFormField(
                               style: const TextStyle(color: kGrey),
                               controller: _emailController,
                               decoration: const InputDecoration(
                                 contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                                 hintText: 'Email',
                                 hintStyle: TextStyle(color: kGrey),
                                 border: InputBorder.none,
                               ),

                             ),
                           ),

                         const SizedBox(height: 10,),
                         if (isLogin!= true)
                           Container(
                             decoration: BoxDecoration(
                                 color: Colors.transparent,
                                 borderRadius: BorderRadius.circular(18.0),
                                 border: const GradientBoxBorder(gradient: LinearGradient(colors: [kPink, kPurple]))

                             ),
                             child: TextFormField(
                               style: TextStyle(color: kGrey),
                               controller: _usernameController,
                               decoration: const InputDecoration(
                                 contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                                 hintText: 'Username',
                                 hintStyle: TextStyle(color: kGrey),
                                 border: InputBorder.none,
                               ),
                             ),
                           ),

                         if (isLogin!= true)
                           const SizedBox(height: 10,),
                         Container(
                           padding: EdgeInsets.only(left: 10, right: 20),
                           decoration: BoxDecoration(
                             color: Colors.transparent,
                             borderRadius: BorderRadius.circular(18.0),
                             border: const GradientBoxBorder(gradient: LinearGradient(colors: [kPink, kPurple]))

                           ),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               SizedBox(width: 8.0),
                               Expanded(
                                 child: TextFormField(
                                   obscureText: showPassword,
                                   style: TextStyle(color: kGrey),
                                   controller: _passwordController,
                                   decoration: InputDecoration(
                                     hintText: 'Password',
                                     hintStyle: TextStyle(color: kGrey),
                                     border: InputBorder.none,
                                   ),
                                 ),
                               ),

                               GestureDetector(
                                 onTap: (){
                                   setState(() {
                                     showPassword = !showPassword;
                                   });
                                 },
                                   child: FaIcon(showPassword? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye, color: kGrey,size: 15,)),
                             ],
                           ),
                         ),
                          SizedBox(height: 20,),

                         ElevatedButton(
                             onPressed: (){
                               if(_formKey.currentState!.validate()) {
                                 isLogin
                                     ? signInWithEmail() : createUserWithEmail();
                               }
                             },
                             style: ElevatedButton.styleFrom(backgroundColor:kPurple, shape: StadiumBorder(), fixedSize:Size( 180, 30)),
                             child: Text(isLogin? 'Login': 'Register', style: kNanumGothicBold,)),
                         Padding(
                           padding: const EdgeInsets.all(10),
                           child: InkWell(
                             onTap: (){
                               setState(() {
                                 isLogin = !isLogin;
                               });
                             },
                             splashColor: Colors.transparent,
                             highlightColor: Colors.transparent,
                             child:Text(isLogin? 'Register Instead': 'Login Instead', style: kNanumGothicMedium.copyWith(color: Colors.blue),)),
                         ),
                        SizedBox(height: 15,),

                        Text('───   Other Methods   ───', style: kNanumGothicMedium.copyWith(color: kDarkGrey),),
                        SizedBox(height: 15,),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(side: BorderSide(color: kPink), shape: StadiumBorder(),padding: EdgeInsets.all(10),fixedSize: Size(240, 40)),
                            onPressed: ()=> Auth().signInWithGoogle(),
                          child:  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/google.png',width: 25,height: 25,),
                            SizedBox(width: 10,),
                            Text.rich(
                                TextSpan(text: 'Sign-in With ',
                                    style: kanumGothicRegular.copyWith(color: kWhite),
                                    children: [
                                      TextSpan(text: 'Google', style: kNanumGothicBold.copyWith(color: kWhite))
                                    ])
                            )
                          ],
                        ),)
                       ],
                     ),
                   )
                 ],
               ),
             ),
           ),

          ))
    );
  }
}
