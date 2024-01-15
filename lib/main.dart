
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friendzo/screens/login_screen.dart';
import 'package:friendzo/screens/splash_screen.dart';


import 'firebase_options.dart';
import 'screens/my_home_page.dart';

late Size size;
void main() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    // DeviceOrientation.portraitUp, DeviceOrientation.portraitDown
  ]).then((value) async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});





  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: AppBarTheme(iconTheme: IconThemeData(
          color: Colors.white
        ),
          centerTitle: true,
          backgroundColor: Colors.green.shade900,
          titleTextStyle: TextStyle(
            fontSize: 20,
            color: Colors.white
          )

        )
      ),
      home: const SplashScreen(),
    );
  }


}

