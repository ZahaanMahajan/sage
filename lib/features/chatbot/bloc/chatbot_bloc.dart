import 'package:bloc/bloc.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:sage_app/repository/chatbot_repository.dart';

part 'chatbot_event.dart';

part 'chatbot_state.dart';

class ChatBotBloc extends Bloc<ChatBotEvent, ChatBotState> {
  final ChatBotRepository chatRepository;
  final ChatUser user;
  final ChatUser sage;
  List<ChatMessage> messages = [];

  ChatBotBloc(this.chatRepository, this.user, this.sage)
      : super(ChatLoadedState([])) {
    on<SendMessageEvent>(_onSendMessage);
  }

  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<ChatBotState> emit) async {
    // Add user message to the list
    messages.insert(0, event.message);
    emit(ChatLoadedState(messages, typingUsers: [sage]));

    try {
      final responses =
          await chatRepository.getChatResponse(messages, user, sage);
      bool hasSensitiveContent = _checkForSensitiveContent(messages);
      // Add bot responses to the list
      messages.insertAll(0, responses);
      emit(ChatLoadedState(messages, showWarning: hasSensitiveContent));
    } catch (e) {
      emit(ChatErrorState(e.toString()));
      emit(ChatLoadedState(messages));
    }
  }

  bool _checkForSensitiveContent(List<ChatMessage> messages) {
    List<String> sensitiveKeywords = ['suicide', 'self harm', 'abuse', 'end life', 'kill'];
    return messages.any(
      (message) => sensitiveKeywords.any(
        (keyword) => message.text.toLowerCase().contains(keyword),
      ),
    );
  }
}
