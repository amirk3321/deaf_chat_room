import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deaf_chat/entities/text_messsage_entity.dart';

class TextMessageModel extends TextMessageEntity {
  TextMessageModel({ String recipientId,
    String senderId,
    String senderName,
    String type,
    Timestamp time,
    String content,
    String receiverName,
    String messageId,String channelId}) : super(
    recipientId: recipientId,
    senderId: senderId,
    senderName: senderName,
    type: type,
    time: time,
    content: content,
    receiverName: receiverName,
    messageId: messageId,
    channelId: channelId,
  );

  factory TextMessageModel.fromSnapshot(DocumentSnapshot snapshot) {
    return TextMessageModel(
      recipientId: snapshot.data()['recipientId'],
      senderId: snapshot.data()['senderId'],
      senderName: snapshot.data()['senderName'],
      type: snapshot.data()['type'],
      time: snapshot.data()['time'],
      content: snapshot.data()['content'],
      receiverName: snapshot.data()['receiverName'],
      messageId: snapshot.data()['messageId'],
      channelId: snapshot.data()['channelId'],

    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "recipientId": recipientId,
      "senderId": senderId,
      "senderName": senderName,
      "type": type,
      "time": time,
      "content": content,
      "receiverName": receiverName,
      "messageId": messageId,
      "channelId": channelId,
    };
  }
}
