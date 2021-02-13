part of 'one_to_one_chat_cubit.dart';

abstract class OneToOneChatState extends Equatable {
  const OneToOneChatState();
}

class OneToOneChatInitial extends OneToOneChatState {
  @override
  List<Object> get props => [];
}

class OneToOneChatLoading extends OneToOneChatState {
  @override
  List<Object> get props => [];
}
class OneToOneChatLoaded extends OneToOneChatState {
  final List<TextMessageEntity> messages;

  OneToOneChatLoaded({this.messages});
  @override
  List<Object> get props => [messages];
}