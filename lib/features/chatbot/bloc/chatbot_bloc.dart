import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sage_app/core/constants/constants.dart';
import 'package:sage_app/core/models/open_ai_completions.dart';
import 'package:sage_app/repository/chatbot_repository.dart';

part 'chatbot_event.dart';

part 'chatbot_state.dart';

class ChatBotBloc extends Bloc<ChatBotEvent, ChatBotState> {
  ChatBotBloc() : super(ChatBotInitial()) {
    on<ChatBotEvent>((event, emit) {
     on<SendMessage>(_onSendMessage);
    });
  }

  Future<void> _onSendMessage(
      SendMessage event, Emitter<ChatBotState> emit) async {
    emit(ChatBotLoading());
    try {
      // Call the OpenAI API
      List<ChatCompletionModel> completions = await ChatBotRepository.getChat(
        text: event.message,
        model: AppConstants.gpt3Model,
      );

      // Combine user message and API response
      List<ChatCompletionModel> updatedMessages = [
        ...state is ChatBotSuccess ? (state as ChatBotSuccess).messages : [],
        ChatCompletionModel(
          id: DateTime.now().toString(),
          text: event.message,
          isUser: true,
        ),
        ...completions
      ];

      emit(ChatBotSuccess(messages: updatedMessages));
    } catch (error) {
      emit(ChatBotFailure(error: error.toString()));
    }
  }
}
