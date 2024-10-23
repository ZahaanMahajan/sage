import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:sage_app/core/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sage_app/repository/chatbot_repository.dart';
import 'package:sage_app/features/anonymous_chat/models/chat_room_model.dart';

part 'chatbot_event.dart';

part 'chatbot_state.dart';

class ChatBotBloc extends Bloc<ChatBotEvent, ChatBotState> {
  final ChatBotRepository chatRepository;
  final ChatUser user;
  final ChatUser sage;
  List<ChatMessage> messages = [];

  ChatBotBloc(this.chatRepository, this.user, this.sage)
      : super(ChatLoadedState([])) {
    on<ChatStartedEvent>(_onChatStarted);
    on<SendMessageEvent>(_onSendMessage);
    on<RequestAnonymousChat>(_requestAnonymousChat);
    on<StartNewSession>(_startNewSession);
  }

  Future<void> _onChatStarted(
      ChatStartedEvent event, Emitter<ChatBotState> emit) async {
    // Load chat history from Firestore
    final loadedMessages =
        await chatRepository.loadChatHistory(user.id, user, sage);
    messages.addAll(loadedMessages);

    // Add the initial message from Sage if there are no messages
    if (messages.isEmpty) {
      final initialMessage = ChatMessage(
        user: sage,
        createdAt: DateTime.now(),
        text: "Hello there, I'm Sage and I'll support you on"
            " your journey towards mental well-being.",
      );
      messages.insert(0, initialMessage);
    }
    emit(ChatLoadedState(List.from(messages)));
  }

  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<ChatBotState> emit) async {
    // Add user message to the list
    messages.insert(0, event.message);
    emit(ChatLoadedState(messages, typingUsers: [sage]));

    // Save the message to Firestore
    await chatRepository.saveChatMessage(user.id, event.message);

    try {
      final responses =
          await chatRepository.getChatResponse(messages, user, sage);
      bool hasSensitiveContent = _checkForSensitiveContent(messages);

      // Add bot responses to the list and save them to Firestore
      for (var response in responses) {
        messages.insert(0, response);
        await chatRepository.saveChatMessage(user.id, response);
      }

      emit(ChatLoadedState(messages, showWarning: hasSensitiveContent));
    } catch (e) {
      emit(ChatErrorState(e.toString()));
      emit(ChatLoadedState(messages));
    }
  }

  bool _checkForSensitiveContent(List<ChatMessage> messages) {
    List<String> sensitiveKeywords = [
      'suicide',
      'self harm',
      'abuse',
      'end life',
      'kill',
      'suicidal',
    ];
    return messages.any(
      (message) => sensitiveKeywords.any(
        (keyword) => message.text.toLowerCase().contains(keyword),
      ),
    );
  }

  FutureOr<void> _requestAnonymousChat(
      RequestAnonymousChat event, Emitter<ChatBotState> emit) async {
    emit(RequestAnonymousChatLoading());
    try {
      final studentToken = await FirebaseMessaging.instance.getToken();
      final summary = await chatRepository.getSummary(messages);
      final checkExistingStudentRequest = await checkExistingRequest();
      if (checkExistingStudentRequest) {
        final response =
            await FirebaseFirestore.instance.collection('chat_room').add(
                  ChatRoomModel(
                    chatRoomId: '',
                    accepted: false,
                    gender: '${UserSession.instance.gender}',
                    summary: summary,
                    lastMessage: '',
                    roomName:
                        'Student ${UserSession.instance.uid!.substring(1, 4)}',
                    studentId: '${UserSession.instance.uid}',
                    teacherId: '',
                    studentToken: '$studentToken',
                    teacherToken: '',
                    unreadMsgCount: 0,
                    updatedAt: Timestamp.fromDate(DateTime.now().toLocal()),
                    createdAt: Timestamp.fromDate(DateTime.now().toLocal()),
                  ).toMap(),
                );
        await FirebaseFirestore.instance
            .collection('chat_room')
            .doc(response.id)
            .update({
          'chat_room_id': response.id,
        });
        emit(RequestAnonymousChatSuccess(List.from(messages)));
      } else {
        emit(RequestAnonymousChatExists(List.from(messages)));
      }
    } catch (error) {
      log('Error: $error');
      emit(RequestAnonymousChatError());
    }
  }

  Future<bool> checkExistingRequest() async {
    final response = await FirebaseFirestore.instance
        .collection('chat_room')
        .where('student_id', isEqualTo: '${UserSession.instance.uid}')
        .limit(1)
        .get();
    return response.docs.isEmpty;
  }

  FutureOr<void> _startNewSession(StartNewSession event, Emitter<ChatBotState> emit) async {
    try {
      // Emit a loading state if necessary
      emit(ChatLoadingState());

      // Fetch the chat messages from Firestore
      final chatDocs = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .collection('chats')
          .get();

      // Delete each chat message document
      for (var doc in chatDocs.docs) {
        await doc.reference.delete();
      }

      // Clear the local messages list
      messages.clear();

      // Optionally, reinsert the initial message from Sage to start the new session
      final initialMessage = ChatMessage(
        user: sage,
        createdAt: DateTime.now(),
        text: "Hello there, I'm Sage. Welcome to a new session. How can I help you today?",
      );
      messages.insert(0, initialMessage);

      // Emit the updated state with the new session messages
      emit(ChatLoadedState(List.from(messages)));
    } catch (e) {
      // Handle any errors by emitting an error state
      emit(ChatErrorState("Error starting new session: ${e.toString()}"));
      emit(ChatLoadedState(List.from(messages)));
    }
  }

}
