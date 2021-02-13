part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}
class Authenticated extends AuthState{
  final String uid;

  Authenticated(this.uid);
  @override
  // TODO: implement props
  List<Object> get props => [this.uid];

}
class UnAuthenticated extends AuthState{

  UnAuthenticated();
  @override
  // TODO: implement props
  List<Object> get props => [];
}
