part of 'conversation_bloc.dart';

@immutable
sealed class ConversationEvent {}

class SendMessage extends ConversationEvent {
  final String message;

  SendMessage(this.message);
}

class GetInitialMessages extends ConversationEvent {
  final String chatRoomid;

  GetInitialMessages({required this.chatRoomid});
}

class LoadMoreChats extends ConversationEvent {
  final String chatRoomid;

  LoadMoreChats({required this.chatRoomid});
}

class UpdateRoomContents extends ConversationEvent {
  final String msg;

  UpdateRoomContents({required this.msg});
}
