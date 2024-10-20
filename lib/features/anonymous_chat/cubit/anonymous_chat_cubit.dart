import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'anonymous_chat_state.dart';

class AnonymousChatCubit extends Cubit<AnonymousChatState> {
  AnonymousChatCubit() : super(AnonymousChatInitial());
}
