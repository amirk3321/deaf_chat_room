import 'package:bloc/bloc.dart';
import 'package:deaf_chat/repository/repository.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  FirebaseRepository _firebaseRepository=FirebaseRepository();
  AuthCubit() : super(AuthInitial());

  Future<void> appStarted()async{
    try{
      bool isSignIn =await _firebaseRepository.isSignIn();
      if (isSignIn){
        final uid=await _firebaseRepository.getCurrentUId();
        emit(Authenticated(uid));
      }else
        emit(UnAuthenticated());
    }catch(_){
      emit(UnAuthenticated());
    }
  }
  Future<void> loggedIn()async{
    try{
      final uid=await _firebaseRepository.getCurrentUId();
      emit(Authenticated(uid));
    }catch(_){
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedOut()async{
    await _firebaseRepository.signOut();
    emit(UnAuthenticated());
  }
}
