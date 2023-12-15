import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sociachatv2/Functions/Authentication/widgetTree.dart';
import 'package:sociachatv2/database/databaseConfig.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sociachatv2/designs/resources/style.dart';

import 'Functions/cameraFunction.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

await Firebase.initializeApp();
  runApp(MaterialApp(
    home: WidgetTree() ,
    debugShowCheckedModeBanner: false,

    theme: ThemeData(
      fontFamily: GoogleFonts.nanumGothic().fontFamily,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: kWhite),
        bodyMedium: TextStyle(color: kWhite),
        bodySmall: TextStyle(color: kWhite),
        displayLarge: TextStyle(color: kWhite),
        displayMedium: TextStyle(color: kWhite),
        displaySmall: TextStyle(color: kWhite),
      )
    ),
  ));
  FlutterNativeSplash.remove();
}


