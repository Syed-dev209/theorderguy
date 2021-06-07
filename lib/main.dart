import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theorderguy/screens/splash.dart';

void main() {
  runApp(MyApp());
  //runApp(GetMaterialApp(home: MyApp()));
}

initpref() async {
  MyApp.prefs = await SharedPreferences.getInstance();
}

class MyApp extends StatelessWidget {
  static SharedPreferences prefs;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initpref();
    return MaterialApp(
      title: 'The Order Guys',
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      debugShowCheckedModeBanner: false,
      //home:
      home: SplashScreen(),
    );
  }
}
