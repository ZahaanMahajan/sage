part of 'chatbot_bloc.dart';

abstract class ChatBotState {}

class ChatInitialState extends ChatBotState {}

class ChatLoadedState extends ChatBotState {
  final List<ChatMessage> messages;
  final List<ChatUser> typingUsers;
  final bool showWarning;

  ChatLoadedState(
    this.messages, {
    this.typingUsers = const [],
    this.showWarning = false,
  });

  List<Object> get props => [messages, typingUsers, showWarning];

  ChatLoadedState copyWith({
    List<ChatMessage>? messages,
    List<ChatUser>? typingUsers,
    bool? showWarning,
  }) {
    return ChatLoadedState(
      messages ?? this.messages,
      typingUsers: typingUsers ?? this.typingUsers,
      showWarning: showWarning ?? this.showWarning,
    );
  }
}

class ChatErrorState extends ChatBotState {
  final String error;

  ChatErrorState(this.error);
}

class RequestAnonymousChatState extends ChatBotState {}

class RequestAnonymousChatLoading extends ChatBotState {}

class RequestAnonymousChatError extends ChatBotState {}

class RequestAnonymousChatSuccess extends ChatLoadedState {
  RequestAnonymousChatSuccess(super.messages);
}

class RequestAnonymousChatExists extends ChatLoadedState {
  RequestAnonymousChatExists(super.messages);
}

