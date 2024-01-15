import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friendzo/apis/apis.dart';
import 'package:friendzo/models/chat_user_model.dart';
import 'package:friendzo/screens/profile.dart';
import 'package:friendzo/widgets/chat_user_card.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<UserFriendzo> _list = [];
  final List<UserFriendzo> _searchList = [];
  bool isSearching = false;

  @override
  void initState() {
    APIs.getSelfInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: WillPopScope(

        onWillPop: (){
           if(isSearching){
             setState(() {
               isSearching = !isSearching;
             });
             return Future.value(false);
           }else{
             return Future.value(true);
           }
        },

        child: Scaffold(
          appBar: AppBar(
            title:  isSearching ? TextField(autofocus: true,cursorColor: Colors.white, style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: "Search",focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))),

              /// Searching logic
              onChanged: (val){
              _searchList.clear();
              for(var i in _list){
                if(i.name!.toLowerCase().contains(val.toLowerCase()) || i.email!.toLowerCase().contains(val.toLowerCase())){
                  _searchList.add(i);
                }
                setState(() {
                  _searchList;
                });
              }
              },

            ) : const Text("Friendzo"),
            leading: IconButton(onPressed: (){}, icon: const Icon(Icons.home)),
            actions: [
              // IconButton(onPressed: (){}, icon: Icon(Icons.camera_alt_outlined)),
              IconButton(onPressed: (){
                setState(() {
                  isSearching = !isSearching;
                });
              }, icon: Icon(isSearching ? CupertinoIcons.clear_circled_solid : Icons.search)),

              IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(user: APIs.me,)));
              }, icon: const Icon(Icons.more_vert))

            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.green.shade200,
            onPressed: ()async{
              await APIs.auth.signOut();
              await GoogleSignIn().signOut();
            },
            child: const Icon(Icons.add_comment_rounded, color: Colors.black87,),
          ),
          body: Container(
            color: Colors.black87,
            child: StreamBuilder(
                stream: APIs.getAllUsers(),
                builder: (context, snapshot) {

                  switch(snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(child: CircularProgressIndicator(),);

                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      _list = data?.map((e) => UserFriendzo.fromJson(e.data()))
                          .toList() ?? [];

                   if(_list.isNotEmpty){
                     return ListView.builder(
                         padding: EdgeInsets.only(top: size.height * 0.0055),
                         physics: const BouncingScrollPhysics(),
                         itemCount:isSearching ? _searchList.length : _list.length,
                         itemBuilder: (context, index) {
                           return ChatUserCard(user:isSearching ? _searchList[index] : _list[index],);

                         }
                     );
                   }else{
                    return const Center(child: Text("No connection found"));
                   }
                  }
                }
                ,),
          )
        ),
      ),
    );
  }


}


