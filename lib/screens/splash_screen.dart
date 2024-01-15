
import 'package:flutter/material.dart';
import 'package:friendzo/apis/apis.dart';
import 'package:friendzo/screens/login_screen.dart';
import 'package:friendzo/screens/my_home_page.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), (){
      if(APIs.auth.currentUser != null){
        print("\nUser:${APIs.auth.currentUser}");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const MyHomePage()));

      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: size.width * .16,
              top: size.height * .150,
              child: Image.asset('asset/image/chat.png')),

          Positioned(
            left: size.width * .20,
            top: size.height * .75,
              child: Text("We Love Friendzo ❤️", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),))
        ],
      )
    );
  }
}
