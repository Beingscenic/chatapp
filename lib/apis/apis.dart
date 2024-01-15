import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:friendzo/models/chat_user_model.dart';

class APIs{
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;


  static User get user => auth.currentUser!;
  static late UserFriendzo me;


  static Future<bool> userExists() async{
    return (await firestore.collection('user_friendzo').doc(user.uid).get()).exists;
  }


  static Future<void> createUser() async {
    final time  = DateTime.now().millisecondsSinceEpoch.toString();

    final userFriendzo = UserFriendzo(
      id: user.uid,
      about: "Hey, I am using Friendzo",
        createdAt: time,
      email: user.email.toString(),
        image: user.photoURL.toString(),
      isOnline: false,
       lastActive: time,
      name: user.displayName.toString(),
       pushToken: '',

    );

    return await firestore.collection('user_friendzo').doc(user.uid).set(userFriendzo.toJson());
}

/// for getting all users from firebase database
   static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(){
     return firestore.collection("user_friendzo").where('id',isNotEqualTo: user.uid).snapshots();
         }

  /// to get all self information
     static Future<void> getSelfInfo() async{
    await firestore.collection('user_friendzo').doc( user.uid).get().then((user) async {

      if(user.exists){
        me = UserFriendzo.fromJson(user.data()!);
      }else{
       await createUser().then((value) => getSelfInfo());
      }
    });

     }

     /// For updating user information

    static updateUserDetail() async{
     await firestore.collection("user_friendzo").doc(user.uid).update({
       'name' : me.name,
       'about' : me.about
     });
    }
}