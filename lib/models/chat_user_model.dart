import 'dart:convert';

class UserFriendzo {
   String? image;
   String? about;
   String? name;
   String? createdAt;
   String? id;
   String? lastActive;
   bool? isOnline;
   String? pushToken;
   String? email;

  UserFriendzo({
    this.image,
    this.about,
    this.name,
    this.createdAt,
    this.id,
    this.lastActive,
    this.isOnline,
    this.pushToken,
    this.email,
  });

  factory UserFriendzo.fromRawJson(String str) => UserFriendzo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserFriendzo.fromJson(Map<String, dynamic> json) => UserFriendzo(
    image: json["image"] ?? '',
    about: json["about"] ?? '',
    name: json["name"] ?? '',
    createdAt: json["created_at"] ?? '',
    id: json["id"] ?? '',
    lastActive: json["last_active"] ?? '',
    isOnline: json["is_online"] ?? '',
    pushToken: json["push_token"] ?? '',
    email: json["email"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "about": about,
    "name": name,
    "created_at": createdAt,
    "id": id,
    "last_active": lastActive,
    "is_online": isOnline,
    "push_token": pushToken,
    "email": email,
  };
}
