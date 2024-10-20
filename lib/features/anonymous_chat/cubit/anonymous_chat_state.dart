part of 'anonymous_chat_cubit.dart';

@immutable
sealed class AnonymousChatState {}

final class AnonymousChatInitial extends AnonymousChatState {}

final class SetRequestFlagToTrueSuccess extends AnonymousChatState {
  final String chatRoomID;

  SetRequestFlagToTrueSuccess({required this.chatRoomID});
}

final class SetRequestFlagToTrueError extends AnonymousChatState {}
