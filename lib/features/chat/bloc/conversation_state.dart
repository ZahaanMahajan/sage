part of 'conversation_bloc.dart';

@immutable
sealed class ConversationState {}

final class ConversationInitial extends ConversationState {}

final class ConversationLoading extends ConversationState {}

final class ConversationLoaded extends ConversationState {}

final class ChatRoomLoadingError extends ConversationState {}
