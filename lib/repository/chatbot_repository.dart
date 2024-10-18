import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:sage_app/core/constants/constants.dart';

class ChatBotRepository {
  final OpenAI _openAI;

  ChatBotRepository(this._openAI);

  Future<List<ChatMessage>> getChatResponse(
      List<ChatMessage> messages, ChatUser user, ChatUser sage) async {
    List<Map<String, dynamic>> messagesHistory = [
      {'role': 'system', 'content': AppConstants.counselorPersona},
      ...messages
          .map((m) {
            return {
              'role': m.user.id == user.id ? 'user' : 'assistant',
              'content': m.text,
            };
          })
          .toList()
          .reversed,
    ];

    final request = ChatCompleteText(
      model: GptTurboChatModel(),
      messages: messagesHistory,
      maxToken: 1000,
    );

    final response = await _openAI.onChatCompletion(request: request);

    if (response == null || response.choices.isEmpty) {
      throw Exception('Failed to get response from API');
    }

    return response.choices.map((choice) {
      return ChatMessage(
        user: sage,
        createdAt: DateTime.now(),
        text: choice.message?.content ?? '',
      );
    }).toList();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveChatMessage(String uid, ChatMessage message) async {
    // Reference to the user's sub-collection 'chats'
    final chatRef = _firestore.collection('users').doc(uid).collection('chats');

    // Add the chat message to the 'chats' sub-collection
    await chatRef.add({
      'text': message.text,
      'userId': message.user.id,
      'userName': message.user.firstName ?? '',
      'createdAt': message.createdAt.toIso8601String(),
    });
  }

  Future<List<ChatMessage>> loadChatHistory(
      String uid, ChatUser user, ChatUser sage) async {
    // Load chat history from Firestore
    final chatRef = _firestore.collection('users').doc(uid).collection('chats');
    final chatDocs = await chatRef.orderBy('createdAt', descending: true).get();

    return chatDocs.docs.map((doc) {
      final data = doc.data();
      final isUser = data['userId'] == user.id;

      return ChatMessage(
        user: isUser ? user : sage,
        text: data['text'] ?? '',
        createdAt: DateTime.parse(data['createdAt']),
      );
    }).toList();
  }
}
