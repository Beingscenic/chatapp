import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:friendzo/models/chat_user_model.dart';


class ChatUserCard extends StatefulWidget {
  final UserFriendzo user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.025, vertical: size.height * 0.0055),
      color: Colors.black87,
      child: InkWell(onTap: (){},
        child: ListTile(
         leading: ClipRRect(
           borderRadius: BorderRadius.circular(size.height * 0.3),
           child: CachedNetworkImage(
             height: size.height * 0.06,
               width: size.height * 0.06,
               imageUrl: widget.user.image.toString(),
             // placeholder: (context, url) => CircularProgressIndicator(),
             errorWidget: (context, url, error) => CircleAvatar(child: Icon(Icons.person),),
           ),
         ),

          trailing: ClipRRect(
              borderRadius: BorderRadius.circular(7.5),
              child: Container(height: 15, width: 15, color: Colors.green.shade400,)),
          title: Text(widget.user.name.toString(), style: TextStyle(color: Colors.white),),
          subtitle: Text(widget.user.about.toString(), style: TextStyle(color: Colors.white70),),
        ),
      ),
    );
  }
}


