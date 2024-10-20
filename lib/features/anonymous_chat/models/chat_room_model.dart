import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  final String chatRoomId;
  final bool accepted;
  final String gender;
  final String lastMessage;
  final String roomName;
  final String studentId;
  final String teacherId;
  final String studentToken;
  final String teacherToken;
  final int unreadMsgCount;
  final Timestamp updatedAt;
  final Timestamp createdAt;

  ChatRoomModel({
    required this.chatRoomId,
    required this.accepted,
    required this.gender,
    required this.lastMessage,
    required this.roomName,
    required this.studentId,
    required this.teacherId,
    required this.studentToken,
    required this.teacherToken,
    required this.unreadMsgCount,
    required this.updatedAt,
    required this.createdAt,
  });

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      chatRoomId: map['chat_room_id'],
      accepted: map['accepted'] ?? false,
      gender: map['gender'] ?? '',
      lastMessage: map['last_message'] ?? '',
      roomName: map['room_name'] ?? '',
      studentId: map['student_id'] ?? '',
      teacherId: map['teacher_id'] ?? '',
      studentToken: map['student_token'] ?? '',
      teacherToken: map['teacher_token'] ?? '',
      unreadMsgCount: map['unread_msg_count'] ?? 0,
      updatedAt: map['updated_at'] as Timestamp,
      createdAt: map['created_at'] as Timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chat_room_id': chatRoomId,
      'accepted': accepted,
      'gender': gender,
      'last_message': lastMessage,
      'room_name': roomName,
      'student_id': studentId,
      'teacher_id': teacherId,
      'student_token': studentToken,
      'teacher_token': teacherToken,
      'unread_msg_count': unreadMsgCount,
      'updated_at': updatedAt,
      'created_at': createdAt,
    };
  }
}
