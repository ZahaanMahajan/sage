import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sage_app/repository/chat_repository.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final List<types.Message> messages = [];
  final Set<String> messageIds = {}; // Store unique message IDs
  String chatRoomId = '';
  final ChatRepository chatRepository = ChatRepository();
  final user = types.User(id: FirebaseAuth.instance.currentUser!.uid);
  DocumentSnapshot? lastDocument;
  StreamSubscription? _messageSubscription;

  ConversationBloc() : super(ConversationInitial()) {
    on<ConversationEvent>((event, emit) {});
    on<SendMessage>(_onSendMessage);
    on<GetInitialMessages>(_getInitialMessages);
    on<LoadMoreChats>(_loadMoreChats);
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ConversationState> emit,
  ) async {
    final result = await chatRepository.sendMessage(data: {
      'chat_room_id': chatRoomId,
      'created_at': DateTime.now().toLocal(),
      'image_link': '',
      'message': event.message,
      'sender_id': user.id,
    });

    result.fold((err) {
      log(err.toString());
      emit(ChatRoomLoadingError());
    }, (right) {
      log(right.toString());
      emit(ConversationLoaded());
    });
  }

  // Fetch initial messages and stream new ones
  Future<void> _getInitialMessages(
      GetInitialMessages event, Emitter<ConversationState> emit) async {
    emit(ConversationLoading());

    try {
      chatRoomId = event.chatRoomid;

      // Fetch initial messages
      final initialMessages = await chatRepository.fetchInitialMessages(
        chatRoomId: event.chatRoomid,
        limit: 10,
      );

      log('Initial messages: $initialMessages');

      // Add only new unique messages
      for (var message in initialMessages.reversed) {
        if (!messageIds.contains(message.id)) {
          messages.add(message);
          messageIds.add(message.id);
        }
      }

      // Stream new messages in real-time
      _messageSubscription = chatRepository
          .streamMessages(chatRoomId: event.chatRoomid)
          .listen((newMessages) {
        addNewMessages(newMessages);
      });
      emit(ConversationLoaded());
    } catch (e) {
      emit(ChatRoomLoadingError());
      log('Error while getting initial messages: $e');
    }
  }

  // Add new messages from the stream
  void addNewMessages(List<types.Message> newMessages) {
    for (var message in newMessages) {
      if (!messageIds.contains(message.id)) {
        messages.insert(0, message);
        messageIds.add(message.id);
      }
    }
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }

  FutureOr<void> _loadMoreChats(
      LoadMoreChats event, Emitter<ConversationState> emit) async {
    if (lastDocument != null) {
      final result = await chatRepository.fetchMoreMessages(
        chatRoomId: chatRoomId,
        lastDocument: lastDocument!,
        limit: 10,
      );

      final olderMessages = result['messages'] as List<types.Message>;
      lastDocument = result['lastDoc'] as DocumentSnapshot?;

      // Add only new unique messages
      for (var message in olderMessages.reversed) {
        if (!messageIds.contains(message.id)) {
          messages.add(message);
          messageIds.add(message.id);
        }
      }
      emit(ConversationLoaded());
    }
  }
}
