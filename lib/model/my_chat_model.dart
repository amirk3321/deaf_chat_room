import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:deaf_chat/entities/my_chat_entity.dart';


class MyChatModel extends MyChatEntity {
  MyChatModel({
    String senderName,
    String recipientName,
    String channelId,
    String recipientUID,
    String senderUID,
    String profileUrl,
    String recentTextMessage,
    bool isRead,
    Timestamp time,
    bool isArchived,
    String recipientPhoneNumber,
    String senderPhoneNumber,
    String subjectName,
    String communicationType,
  }) : super(
      senderName:senderName,
      recipientName:recipientName,
      channelId:channelId,
      recipientUID:recipientUID,
      senderUID:senderUID,
      profileUrl:profileUrl,
      recentTextMessage:recentTextMessage,
      isRead:isRead,
      time:time,
      isArchived:isArchived,
      recipientPhoneNumber:recipientPhoneNumber,
      senderPhoneNumber:senderPhoneNumber,
      subjectName:subjectName,
      communicationType:communicationType,
  );

factory MyChatModel.fromSnapshot(DocumentSnapshot snapshot) {
  return MyChatModel(
    senderName: snapshot.data()['senderName'],
    recipientName: snapshot.data()['recipientName'],
    channelId: snapshot.data()['channelId'],
    recipientUID: snapshot.data()['recipientUID'],
    senderUID: snapshot.data()['senderUID'],
    profileUrl: snapshot.data()['profileUrl'],
    recentTextMessage: snapshot.data()['recentTextMessage'],
    isRead: snapshot.data()['isRead'],
    time: snapshot.data()['time'],
    isArchived: snapshot.data()['isArchived'],
    recipientPhoneNumber: snapshot.data()['recipientPhoneNumber'],
    senderPhoneNumber: snapshot.data()['senderPhoneNumber'],
    subjectName: snapshot.data()['subjectName'],
    communicationType: snapshot.data()['communicationType'],
  );
}

Map<String, dynamic> toDocument() {
  return {
    "senderName": senderName,
    "recipientName": recipientName,
    "channelId": channelId,
    "recipientUID": recipientUID,
    "senderUID": senderUID,
    "profileUrl": profileUrl,
    "recentTextMessage": recentTextMessage,
    "isRead": isRead,
    "time": time,
    "isArchived": isArchived,
    "recipientPhoneNumber": recipientPhoneNumber,
    "senderPhoneNumber": senderPhoneNumber,
    "subjectName":subjectName,
    "communicationType":communicationType
  };
}
}
