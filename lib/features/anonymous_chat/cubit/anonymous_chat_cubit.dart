import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sage_app/repository/anonymous_chat_repository.dart';

part 'anonymous_chat_state.dart';

class AnonymousChatCubit extends Cubit<AnonymousChatState> {
  AnonymousChatCubit() : super(AnonymousChatInitial());

  Future<void> setRequestFlagToTrue(String chatRoomId) async {
    try {
      await AnonymousChatRepository().setRequestFlagToTrue(chatRoomId);

      emit(SetRequestFlagToTrueSuccess(chatRoomID: chatRoomId));
    } catch (e) {
      log('Cubit Erros in setting the chat request flag: $e');
      emit(SetRequestFlagToTrueError());
    }
  }
}
