import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:friendzo/models/chat_user_model.dart';
import 'package:friendzo/screens/login_screen.dart';
import 'package:friendzo/widgets/dialogs.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../apis/apis.dart';


class ProfileScreen extends StatefulWidget {
  final UserFriendzo user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final _formKey = GlobalKey<FormState>();
  String? iimage;


  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Profile"),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.red.shade400,
          onPressed: ()async{
            Dialogs.showProgressBar(context);
            await APIs.auth.signOut().then((value) async {
              await GoogleSignIn().signOut().then((value) {

                Navigator.pop(context);
                ///Moving to home screen
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const LoginScreen()));
              });
            });

          },
          label: const Text("Logout", style: TextStyle(color: Colors.white),),icon:  const Icon(Icons.add_comment_rounded, color: Colors.white,),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: SingleChildScrollView(
              child: Column(
                children: [

                  SizedBox(width: size.width,),

                  Container(height: size.height * 0.2,
                            width: size.height * 0.2,
                    child: Stack(
                      children: [

                        if(iimage != null)
                        Hero(
                          tag: 'hero-rectangle',
                          child: GestureDetector(
                            onTap: (){
                               gotoDetailsPage(context,iimage!);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(size.height * 0.1),
                              child: Image.file(
                                File(iimage!),
                                height: size.height * 0.2,
                                width: size.height * 0.2,
                                fit: BoxFit.cover,

                              ),
                            ),
                          ),
                        ),



                        Positioned(
                          top: 95,
                          left: 95,
                          child: IconButton(onPressed: (){
                            _showBottomSheet();
                          }, icon: const CircleAvatar(child: Icon(Icons.edit),),),
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: size.height * 0.02,),

                  Text(widget.user.email.toString()),

                  SizedBox(height: size.height * 0.02,),

                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => APIs.me.name = val ?? '',
                    validator: (val) => val != null && val.isNotEmpty ? null : 'Please enter required field',
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(size.height*0.02),
                        borderSide: const BorderSide(color: Colors.white70, style: BorderStyle.solid),
                      ),
                      hintText: "Enter your name",
                      prefixIcon: const Icon(Icons.person, size: 25,),
                      label: const Text("Name")
                    ),
                  ),

                  SizedBox(height: size.height * 0.02,),

                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) => APIs.me.about = val ?? '',
                    validator: (val) => val != null && val.isNotEmpty ? null : "Please enter required field",
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(size.height* 0.02),
                        borderSide: const BorderSide(color: Colors.white70)
                      ),
                      hintText: "Enter your about",
                      prefixIcon: Icon(Icons.info),
                      label: const Text("About")
                    ),
                  ),

                  SizedBox(height: size.height * 0.02,),

                  ElevatedButton.icon(onPressed: (){
                    if(_formKey.currentState!.validate()){
                      print("Inside Validator");
                      _formKey.currentState!.save();
                      APIs.updateUserDetail().then((value) {
                        Dialogs.showSnackbar(context, 'Updated!');
                      });
                    }
                  } , icon: const Icon(Icons.edit), label: const Text("Create"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(size.width*.9, size.width*.1)
                  )
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );

  }

  void gotoDetailsPage(BuildContext context, String myImagee) {
    var size = MediaQuery.of(context).size;
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) => Scaffold(
        appBar: AppBar(
          title:  Text(APIs.user.displayName.toString()),
        ),
        body:  Center(
          child: Hero(
            transitionOnUserGestures: true,
            tag: 'hero-rectangle',
            child: Container(
              // width: size.width,
              // height: size.height*0.75,
              child: Image.file(
                File(myImagee),
                height: size.height * 0.50,
                width: size.width,
                fit: BoxFit.cover,

              ),
            ),
          ),
        ),
      ),
    ));
  }

  /// Bottom sheet for picking a profile picture for uder
  void _showBottomSheet(){
    final size = MediaQuery.of(context).size;
    showModalBottomSheet(
      backgroundColor: Colors.green.shade900,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
        ),
        context: context, builder: (_){
      return ListView(
        shrinkWrap: true,
        children: [
          const Center(child: Padding(
            padding: EdgeInsets.only(top: 25, bottom: 25),
            child: Text("Pick profile picture", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
          )),



          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  fixedSize: Size(size.width*0.25, size.width*0.25)
                ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
// Pick an image.
                    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                    if(image != null){
                      log('Image path:${image.path} --MimeType ${image.name}');
                      setState(() {
                        iimage = image.path;
                      });
                      Navigator.pop(context);
                    }

                  },
                  child: Image.asset('asset/image/gallery.png')),

              ElevatedButton(
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
// Pick an image.
                  final XFile? image = await picker.pickImage(source: ImageSource.camera);
                  if(image != null){
                    log('Image path:${image.path}');
                    setState(() {
                      iimage = image.path;
                    });
                    Navigator.pop(context);
                  }

                },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                fixedSize: Size(size.width*0.25, size.width*0.25)
              ), child: Image.asset("asset/image/camera.png") ,
              )
            ],
          ),

          SizedBox(
            height: size.height*0.035,
          )
        ],
      );
    });
  }
}
