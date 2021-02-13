import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deaf_chat/entities/user_entity.dart';


class UserModel extends UserEntity {
  UserModel({
    String name = "username",
    String email = "",
    String phoneNumber,
    bool isOnline,
    String uid,
    String status = "",
    String profileUrl = "",
  }) : super(
          name: name,
          email: email,
          phoneNumber: phoneNumber,
          isOnline: isOnline,
          uid: uid,
          status: status,
          profileUrl: profileUrl,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      isOnline: json['isOnline'],
      uid: json['uid'],
      status: json['status'],
      profileUrl: json['profileUrl'],
    );
  }

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    return UserModel(
      name: snapshot.data()['name'],
      email: snapshot.data()['email'],
      phoneNumber: snapshot.data()['phoneNumber'],
      isOnline: snapshot.data()['isOnline'],
      uid: snapshot.data()['uid'],
      status: snapshot.data()['status'],
      profileUrl: snapshot.data()['profileUrl'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "name": name,
      "email": email,
      "phoneNumber": phoneNumber,
      "isOnline": isOnline,
      "uid": uid,
      "status": status,
      "profileUrl": profileUrl,
    };
  }
}
