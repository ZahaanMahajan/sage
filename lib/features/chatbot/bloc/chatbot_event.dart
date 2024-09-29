part of 'chatbot_bloc.dart';

@immutable
sealed class ChatBotEvent {}

class SendMessage extends ChatBotEvent {
  final String message;

  SendMessage({required this.message});
}

class ReceiveMessage extends ChatBotEvent {
  final List<ChatCompletionModel> completions;

  ReceiveMessage({required this.completions});
}
