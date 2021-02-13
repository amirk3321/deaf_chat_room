import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:deaf_chat/entities/user_entity.dart';
import 'package:deaf_chat/repository/repository.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  FirebaseRepository _firebaseRepository = FirebaseRepository();

  LoginCubit() : super(LoginInitial());

  Future<void> signInInSubmit({String email, String password}) async {
    emit(LoginLoading());
    try {
     await _firebaseRepository.signIn(email, password);
      emit(LoginSuccess());
    } on SocketException catch (_) {
      emit(LoginFailure());
    } catch (_) {
      emit(LoginFailure());
    }
  }


  Future<void> signUpSubmit(
      {String email, String password, String name}) async {
    emit(LoginLoading());
    try {
      await _firebaseRepository.signUp(email, password);

      await _firebaseRepository.getCreateCurrentUser(UserEntity(
          email: email,
          name: name,
          phoneNumber: "",
          profileUrl: "",
          isOnline: true,
          status: ""));
      emit(LoginSuccess());
    } on SocketException catch (_) {
      emit(LoginFailure());
    } catch (_) {
      emit(LoginFailure());
    }
  }
}
