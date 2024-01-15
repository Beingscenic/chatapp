import 'dart:developer';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friendzo/screens/my_home_page.dart';
import 'package:friendzo/widgets/dialogs.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../apis/apis.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

   bool _isAnimated = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), (){
      setState(() {
        _isAnimated = true;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome to Friendzo"),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(seconds: 1),
              top: size.height * .15,
              // left: size.width * .30,
              right: _isAnimated? size.width * .30: -size.width * .5,
              child: Image.asset(
                "asset/image/chat.png",
                scale: 1.5,
              )),

          Positioned(
              top: size.height * .60,
              left: size.width * .15,
              width: size.width * .75,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,

                ),
                  onPressed: () {
                _handleGoogleBtnClick();
                  },
                  icon: Image.asset(
                    "asset/image/google.jpeg",
                    height: size.height * .04,
                    // width: size.width * .25,
                  ),
                  label: RichText(
                      text: const TextSpan(children: [
                    TextSpan(
                        text: "Sign In with",
                        style: TextStyle(color: Colors.black)),
                    TextSpan(
                        text: " Google",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold))
                  ]))))
        ],
      ),
    );
  }

   _handleGoogleBtnClick(){
    Dialogs.showProgressBar(context);
     _signInWithGoogle().then((user) async {
       Navigator.pop(context);

       // var connectivityResult = await Connectivity().checkConnectivity();
       // if (connectivityResult == ConnectivityResult.none) {
       //   Navigator.pop(context);
       //   Dialogs.showSnackbar(context, "No internet connection");
       //   return;
       // }


       
      if(user != null){
        log('\nUser: ${user.user}');
        log('\nUserAdditionalInfo: ${user.additionalUserInfo}');

        if(await APIs.userExists()){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const MyHomePage()));
        }
        else{
          await APIs.createUser().then((value) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const MyHomePage()));
          });
        }
      }
     });
   }

   Future<UserCredential?> _signInWithGoogle() async {

     // Check for internet connectivity
     var connectivityResult = await Connectivity().checkConnectivity();
     // Trigger the authentication flow
     try{
       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

       // Obtain the auth details from the request
       final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

       // Create a new credential
       final credential = GoogleAuthProvider.credential(
         accessToken: googleAuth?.accessToken,
         idToken: googleAuth?.idToken,
       );

       // Once signed in, return the UserCredential
       return await APIs.auth.signInWithCredential(credential);
     }catch(e){
       log('\n_signInWithGoogle');

       // if (connectivityResult == ConnectivityResult.none) {
       //   Navigator.pop(context);
       //   Dialogs.showSnackbar(context, "Something wents wrong!, check internet connectivity");
       // }else{
       //   return null;
       // }

       Dialogs.showSnackbar(context, "Something wents wrong!, check internet connectivity");

       //
       return null;
     }
   }
}
