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
  List<types.Message> messages = [];
  Set<String> messageIds = {};
  String chatRoomId = '';
  final ChatRepository chatRepository = ChatRepository();
  final user = types.User(id: FirebaseAuth.instance.currentUser!.uid);
  DocumentSnapshot? lastDocument;
  StreamSubscription? _messageSubscription;
  String messageingToken = '';

  ConversationBloc() : super(ConversationInitial()) {
    on<ConversationEvent>((event, emit) {});
    on<SendMessage>(_onSendMessage);
    on<GetInitialMessages>(_getInitialMessages);
    on<LoadMoreChats>(_loadMoreChats);
    on<UpdateRoomContents>(_updateRoomContents);
  }

  Stream<List<types.Message>> get messageStream =>
      chatRepository.streamMessages(chatRoomId: chatRoomId);

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
    });
  }

  // Fetch initial messages and stream new ones
  Future<void> _getInitialMessages(
      GetInitialMessages event, Emitter<ConversationState> emit) async {
    emit(ConversationLoading());

    try {
      messages = [];
      chatRoomId = event.chatRoomid;

      // Fetch initial messages
      final initialMessages = await chatRepository.fetchInitialMessages(
        chatRoomId: event.chatRoomid,
        limit: 12,
      );

      log('Initial messages: $initialMessages');

      // Add only new unique messages
      for (var message in initialMessages['messages']) {
        if (!messageIds.contains(message.id)) {
          messages.add(message);
          messageIds.add(message.id);
        }
      }

      lastDocument = initialMessages['lastDoc'];

      log('out of the stream');
      emit(ConversationLoaded());
    } catch (e) {
      emit(ChatRoomLoadingError());
      log('Error while getting initial messages: $e');
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
        chatRoomId: event.chatRoomid,
        lastDocument: lastDocument!,
        limit: 10,
      );

      final olderMessages = result['messages'] as List<types.Message>;
      lastDocument = result['lastDoc'] as DocumentSnapshot?;

      // Add only new unique messages
      for (var message in olderMessages) {
        if (!messageIds.contains(message.id)) {
          log(message.toString());
          messages.add(message);
          messageIds.add(message.id);
        }
      }
    }
  }

  FutureOr<void> _updateRoomContents(
      UpdateRoomContents event, Emitter<ConversationState> emit) async {
    // try {
    //   // Create the FCM payload
    //   final body = {
    //     "registration_ids": [messageingToken],
    //     "notification": {
    //       "title": "New Message",
    //       "body": 'This is FCM',
    //       "sound": "default"
    //     },
    //     "data": {
    //       "click_action": "FLUTTER_NOTIFICATION_CLICK",
    //       "message": 'This is FCM',
    //     }
    //   };

    //   // Send the FCM message using Firebase's FCM REST API
    //   await FirebaseMessaging.instance.;

    //   log("FCM message sent successfully");
    // } catch (e) {
    //   log("Error sending FCM message: $e");
    // }
  }
}
