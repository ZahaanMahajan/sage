import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'chatbot_event.dart';
part 'chatbot_state.dart';

class ChatBotBloc extends Bloc<ChatBotEvent, ChatBotState> {
  ChatBotBloc() : super(ChatBotInitial()) {
    on<ChatBotEvent>((event, emit) {
      // TODO: implement event handler
    });

  }
}

/*

OpenAiCompletionsCubit({required this.apiRepository})
      : super(OpenAiCompletionsState.initial());

  // set current message
  void setCurrentMessage(String text) {
    emit(state.copyWith(currentMessage: text));
  }

  // set completion
  void setCompletion({required List<OpenAICompletion> completions}) {
    List<OpenAICompletion> newCompletions = state.completions;
    newCompletions.addAll(completions);
    emit(state.copyWith(completions: newCompletions));
  }

  // set chat
  void setChats({required List<OpenAICompletion> chats}) {
    List<OpenAICompletion> newChats = state.chats;
    newChats.addAll(chats);
    emit(state.copyWith(chats: newChats));
  }

  // toggle isLiked
  void toggleCompletionIsLike({
    required String id,
    required bool value,
    required OperationType operationType,
  }) {
    List<OpenAICompletion> newList = [];
    switch (operationType) {
      case OperationType.completion:
        newList = state.completions.map((OpenAICompletion completion) {
          if (completion.id == id) {
            return OpenAICompletion(
              id: completion.id,
              text: completion.text,
              isLiked: value,
              isUser: false,
            );
          }
          return completion;
        }).toList();
        emit(state.copyWith(completions: newList));
        break;

      case OperationType.chat:
        newList = state.chats.map((OpenAICompletion chat) {
          if (chat.id == id) {
            return OpenAICompletion(
              id: chat.id,
              text: chat.text,
              isLiked: value,
              isUser: false,
            );
          }
          return chat;
        }).toList();
        print(newList);
        emit(state.copyWith(chats: newList));
        break;
    }
  }


*/