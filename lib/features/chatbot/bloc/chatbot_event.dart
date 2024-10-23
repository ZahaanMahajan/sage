part of 'chatbot_bloc.dart';

abstract class ChatBotEvent {}

class ChatStartedEvent extends ChatBotEvent {}

class SendMessageEvent extends ChatBotEvent {
  final ChatMessage message;

  SendMessageEvent(this.message);
}

class RequestAnonymousChat extends ChatBotEvent {}

class StartNewSession extends ChatBotEvent {}
