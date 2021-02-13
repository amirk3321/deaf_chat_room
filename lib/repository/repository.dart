

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deaf_chat/entities/my_chat_entity.dart';
import 'package:deaf_chat/entities/text_messsage_entity.dart';
import 'package:deaf_chat/entities/user_entity.dart';
import 'package:deaf_chat/model/my_chat_model.dart';
import 'package:deaf_chat/model/text_message_model.dart';
import 'package:deaf_chat/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MyException implements Exception{}
class FirebaseRepository {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;


  Future<void> getCreateCurrentUser(UserEntity user) async {
    final userCollection = fireStore.collection("users");
    final uid = await getCurrentUId();
    userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
        name: user.name,
        uid: uid,
        phoneNumber: user.phoneNumber,
        email: user.email,
        profileUrl: user.profileUrl,
        isOnline: user.isOnline,
        status: user.status,
      ).toDocument();
      if (!userDoc.exists) {
        userCollection.doc(uid).set(newUser);
        return;
      } else {
        userCollection.doc(uid).update(newUser);
        print("user already exist");
        return;
      }
    }).catchError((error) {
      print(error);
    });
  }

  Future<String> getCurrentUId() async => auth.currentUser.uid;

  Future<bool> isSignIn() async => auth.currentUser.uid != null;

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<void> signIn(String email, String password) async {
    return await auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signUp(String email, String password) {
    return auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<String> getOneToOneSingleUserChannelId(String uid, String otherUid) {
    final userCollectionRef = fireStore.collection("users");
    print("uid $uid - otherUid $otherUid");
    return userCollectionRef
        .doc(uid)
        .collection('chatChannel')
        .doc(otherUid)
        .get()
        .then((chatChannelId) {
      if (chatChannelId.exists) {
        return chatChannelId.data()['channelId'];
      } else
        return Future.value(null);
    });
  }

  Stream<List<UserEntity>> getAllUsers() {
    final userCollection = fireStore.collection("users");
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }


  Future<void> createOneToOneChatChannel({String uid,
    String otherUid,
    Function(String channelId) onComplete}) async {
    //User Collection Reference
    final userCollectionRef = fireStore.collection("users");

    final oneToOneChatChannelRef = fireStore.collection("OneToOneChatChannel");
    //ChatChannelMap
    userCollectionRef
        .doc(uid)
        .collection("chatChannel")
        .doc(otherUid)
        .get()
        .then((chatChannelDoc) {
      //Chat Channel exists
      if (chatChannelDoc.exists) {
        onComplete(chatChannelDoc.data()['channelId']);
        return;
      }

      final _chatChannelId = oneToOneChatChannelRef
          .doc()
          .id;

      var channel = {'channelId': _chatChannelId};
      var channel1 = {
        'channelId': _chatChannelId,

      };

      oneToOneChatChannelRef.doc(_chatChannelId).set(channel);

      //currentUser
      userCollectionRef
          .doc(uid)
          .collection('chatChannel')
          .doc(otherUid)
          .set(channel);

      //otherUser
      userCollectionRef
          .doc(otherUid)
          .collection('chatChannel')
          .doc(uid)
          .set(channel);

      onComplete(_chatChannelId);
      return;
    });
  }

  Future<void> sendTextMessage(TextMessageEntity textMessageEntity,
      String channelId) async {
    final messagesRef = fireStore
        .collection("OneToOneChatChannel")
        .doc(channelId)
        .collection("messages");

    //MessageId
    final messageId = messagesRef
        .doc()
        .id;

    final newMessage = TextMessageModel(
      content: textMessageEntity.content,
      messageId: messageId,
      receiverName: textMessageEntity.receiverName,
      recipientId: textMessageEntity.recipientId,
      senderId: textMessageEntity.senderId,
      senderName: textMessageEntity.senderName,
      time: textMessageEntity.time,
      type: textMessageEntity.type,
      channelId: textMessageEntity.channelId
    ).toDocument();

    messagesRef.doc(messageId).set(newMessage);
  }

  Stream<List<TextMessageEntity>> getMessages(String channelId) {
    final oneToOneChatChannelRef = fireStore.collection("OneToOneChatChannel");
    final messagesRef =
    oneToOneChatChannelRef.doc(channelId).collection("messages");

    return messagesRef.orderBy('time').snapshots().map((querySnap) =>
        querySnap
            .docs
            .map((queryDoc) => TextMessageModel.fromSnapshot(queryDoc))
            .toList());
  }

  Future<void> addToMyChat(MyChatEntity myChatEntity) async {
    final myChatRef = fireStore
        .collection("users")
        .doc(myChatEntity.senderUID)
        .collection("myChat");
    final otherChatRef = fireStore
        .collection("users")
        .doc(myChatEntity.recipientUID)
        .collection("myChat");

    final myNewChatCurrentUser = MyChatModel(
      channelId: myChatEntity.channelId,
      senderName: myChatEntity.senderName,
      time: myChatEntity.time,
      recipientName: myChatEntity.recipientName,
      recipientPhoneNumber: myChatEntity.recipientPhoneNumber,
      recipientUID: myChatEntity.recipientUID,
      senderPhoneNumber: myChatEntity.senderPhoneNumber,
      senderUID: myChatEntity.senderUID,
      profileUrl: myChatEntity.profileUrl,
      isArchived: myChatEntity.isArchived,
      isRead: myChatEntity.isRead,
      recentTextMessage: myChatEntity.recentTextMessage,
      subjectName: myChatEntity.subjectName,
    ).toDocument();
    final myNewChatOtherUser = MyChatModel(
      channelId: myChatEntity.channelId,
      senderName: myChatEntity.recipientName,
      time: myChatEntity.time,
      recipientName: myChatEntity.senderName,
      recipientPhoneNumber: myChatEntity.senderPhoneNumber,
      recipientUID: myChatEntity.senderUID,
      senderPhoneNumber: myChatEntity.recipientPhoneNumber,
      senderUID: myChatEntity.recipientUID,
      profileUrl: myChatEntity.profileUrl,
      isArchived: myChatEntity.isArchived,
      isRead: myChatEntity.isRead,
      recentTextMessage: myChatEntity.recentTextMessage,
      subjectName: myChatEntity.subjectName,
    ).toDocument();
    myChatRef.doc(myChatEntity.recipientUID).get().then((myChatDoc) {
      if (!myChatDoc.exists) {
        myChatRef.doc(myChatEntity.recipientUID).set(myNewChatCurrentUser);
        otherChatRef.doc(myChatEntity.senderUID).set(myNewChatOtherUser);
        return;
      } else {
        print("update");
        myChatRef.doc(myChatEntity.recipientUID).update(myNewChatCurrentUser);
        otherChatRef.doc(myChatEntity.senderUID).set(myNewChatOtherUser);

        return;
      }
    });
  }

  Stream<List<MyChatEntity>> getMyChat(String uid) {
    final myChatRef =
    fireStore.collection("users").doc(uid).collection("myChat");

    return myChatRef.orderBy('time', descending: true).snapshots().map(
          (querySnapshot) {
        return querySnapshot.docs.map((queryDocumentSnapshot) {
          return MyChatModel.fromSnapshot(queryDocumentSnapshot);
        }).toList();
      },
    );
  }

  Future<void> deleteSingleMessage(
      {String channelId, String messageId}) async {
    final oneToOneChatChannelRef = fireStore.collection("OneToOneChatChannel");

   await oneToOneChatChannelRef
          .doc(channelId)
          .collection("messages")
          .doc(messageId)
          .delete();
}

}