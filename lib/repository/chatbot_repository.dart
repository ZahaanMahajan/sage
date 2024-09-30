import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:sage_app/core/constants/constants.dart';

class ChatBotRepository {
  final OpenAI _openAI;

  ChatBotRepository(this._openAI);

  Future<List<ChatMessage>> getChatResponse(List<ChatMessage> messages,
      ChatUser user, ChatUser sage) async {
    List<Map<String, dynamic>> messagesHistory = [
      {'role': 'system', 'content': AppConstants.counselorPersona},
      ...messages.map((m) {
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
}