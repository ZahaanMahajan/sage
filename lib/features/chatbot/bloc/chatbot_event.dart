part of 'chatbot_bloc.dart';

abstract class ChatBotEvent {}

class SendMessageEvent extends ChatBotEvent {
  final ChatMessage message;

  SendMessageEvent(this.message);
}