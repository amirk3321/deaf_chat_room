import 'package:bloc/bloc.dart';
import 'package:deaf_chat/entities/user_entity.dart';
import 'package:deaf_chat/repository/repository.dart';
import 'package:equatable/equatable.dart';
part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  FirebaseRepository _firebaseRepository=FirebaseRepository();
  UserCubit() : super(UserInitial());

  Future<void> getAllUsers()async{
    try{
      final result=_firebaseRepository.getAllUsers();
      result.listen((users) {
        emit(UserLoaded(users: users));
      });
    }catch(_){

    }
  }
  Future<void> createChatChannel({String uid,String otherUid})async{
    try{
      await _firebaseRepository.createOneToOneChatChannel(uid: uid,otherUid: otherUid,onComplete: (channelId){

      });
      print("user");
    }catch(_){
      print("failure");
    }
  }
  Future<void> getChatChannel({String uid,String otherUid})async{
    try{
      final channelId=await _firebaseRepository.getOneToOneSingleUserChannelId(uid,otherUid);
      print(channelId);
      print("user");
    }catch(_){
      print("failure");
    }
  }
  Future<void> deleteMessage({String channelId,String messageId})async{
    try{
      await _firebaseRepository.deleteSingleMessage(channelId:channelId,messageId: messageId);
      print("user");
    }catch(_){
      print("failure");
    }
  }
}
