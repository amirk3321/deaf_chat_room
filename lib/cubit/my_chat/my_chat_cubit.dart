import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:deaf_chat/entities/my_chat_entity.dart';
import 'package:deaf_chat/repository/repository.dart';
import 'package:equatable/equatable.dart';
part 'my_chat_state.dart';

class MyChatCubit extends Cubit<MyChatState> {
  FirebaseRepository _firebaseRepository=FirebaseRepository();
  MyChatCubit() : super(MyChatInitial());

  Future<void> getMyChat({String uid})async{
    try {
      final myChat=_firebaseRepository.getMyChat(uid);
      myChat.listen((myChatData) {
        emit(MyChatLoaded(myChat: myChatData));
      });
    } on SocketException catch (_) {} catch (_) {}
  }
}
