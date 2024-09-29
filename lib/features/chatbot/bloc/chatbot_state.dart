part of 'chatbot_bloc.dart';

@immutable
sealed class ChatBotState {}

final class ChatBotInitial extends ChatBotState {}

class ChatBotLoading extends ChatBotState {}

class ChatBotSuccess extends ChatBotState {
  final List<ChatCompletionModel> messages;

  ChatBotSuccess({required this.messages});
}

class ChatBotFailure extends ChatBotState {
  final String error;

  ChatBotFailure({required this.error});
}
