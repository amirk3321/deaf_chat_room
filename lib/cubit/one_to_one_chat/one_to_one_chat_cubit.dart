import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deaf_chat/entities/my_chat_entity.dart';
import 'package:deaf_chat/entities/text_messsage_entity.dart';
import 'package:deaf_chat/repository/repository.dart';
import 'package:equatable/equatable.dart';
part 'one_to_one_chat_state.dart';

class OneToOneChatCubit extends Cubit<OneToOneChatState> {
  FirebaseRepository _firebaseRepository=FirebaseRepository();
  OneToOneChatCubit() : super(OneToOneChatInitial());

  Future<void> getMessages({String senderId, String recipientId,String myChannelId}) async {
    emit(OneToOneChatLoading());
    try {


      final channelId =await _firebaseRepository.getOneToOneSingleUserChannelId(senderId, recipientId);
      print("myChannelId $channelId");
      final messagesStreamData = _firebaseRepository.getMessages(channelId==null?myChannelId:channelId);
      messagesStreamData.listen((messages) {
        print("new data added - OneToOneChatLoaded");
        emit(OneToOneChatLoaded(messages: messages));
      });
    } on SocketException catch (_) {} catch (_) {}
  }

  Future<void> sendTextMessage({
    String senderName,
    String senderId,
    String recipientId,
    String receiverName,
    String content,
    String recipientPhoneNumber,
    String senderPhoneNumber,
    String messageType
  }) async {
    try {
      final channelId = await _firebaseRepository.getOneToOneSingleUserChannelId(
          senderId, recipientId);
      print(channelId);
      await _firebaseRepository.sendTextMessage(
          TextMessageEntity(
            type: messageType,
            time: Timestamp.now(),
            senderName: senderName,
            senderId: senderId,
            recipientId: recipientId,
            receiverName: receiverName,
            content: content,
            messageId: "",
            channelId: channelId,
          ),
          channelId);

      await _firebaseRepository.addToMyChat(
        MyChatEntity(
          recentTextMessage: content,
          recipientUID: recipientId,
          isRead: true,
          isArchived: false,
          profileUrl: "",
          recipientName: receiverName,
          senderUID: senderId,
          time: Timestamp.now(),
          senderName: senderName,
          channelId: channelId,
          recipientPhoneNumber: recipientPhoneNumber,
          senderPhoneNumber: senderPhoneNumber,
        ),
      );
    } on SocketException catch (_) {
      print("no internet");
    } catch (_) {
      print("data failure");
    }
  }
}
