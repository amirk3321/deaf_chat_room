
class UserEntity{
  final String name;
  final String email;
  final String phoneNumber;
  final bool isOnline;
  final String uid;
  final String status;
  final String profileUrl;

  UserEntity({this.name, this.email, this.phoneNumber, this.isOnline=false, this.uid, this.status="Hello there i'm using this app", this.profileUrl});
}