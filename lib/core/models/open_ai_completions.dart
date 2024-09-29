import 'package:equatable/equatable.dart';

class ChatCompletionModel {
  final String id;
  final String text;
  bool isUser;

  ChatCompletionModel({
    required this.id,
    required this.text,
    this.isUser = false,
  });

  factory ChatCompletionModel.fromJson(Map<String, dynamic> data) =>
      ChatCompletionModel(
        id: data['id'],
        text: data['text'],
      );

  factory ChatCompletionModel.initial() => ChatCompletionModel(id: '', text: '');

  static List<ChatCompletionModel> toListCompletions(List completions) {
    return completions.map((data) => ChatCompletionModel.fromJson(data)).toList();
  }
}
