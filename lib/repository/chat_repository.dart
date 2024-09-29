// ignore_for_file: unused_field

import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatRepository {
  //* =============== Variables  =============== *//
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //* =============== Send maessage  =============== *//
  Future<Either<Exception, dynamic>> sendMessage(
      {required Map<String, dynamic> data}) async {
    try {
      // Add the document and get the reference
      final docRef = await _firestore.collection('messages').add(data);

      // Get the document ID
      final messageId = docRef.id;

      // Update the document with the message ID
      await docRef.update({'message_id': messageId});

      return Right(docRef);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

// Fetch initial messages with chat_room_id and pagination
  Future<List<types.Message>> fetchInitialMessages({
    required String chatRoomId,
    required int limit,
  }) async {
    final snapshot = await _firestore
        .collection('messages')
        .where('chat_room_id', isEqualTo: chatRoomId)
        .orderBy('created_at', descending: false)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) => _mapDocumentToMessage(doc)).toList();
  }

  // Stream new messages with chat_room_id
  Stream<List<types.Message>> streamMessages({
    required String chatRoomId,
  }) {
    return _firestore
        .collection('messages')
        .where('chat_room_id', isEqualTo: chatRoomId)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => _mapDocumentToMessage(doc)).toList());
  }

  // Pagination: Fetch older messages
  Future<Map<String, dynamic>> fetchMoreMessages({
    required String chatRoomId,
    required DocumentSnapshot lastDocument,
    required int limit,
  }) async {
    final snapshot = await _firestore
        .collection('messages')
        .where('chat_room_id', isEqualTo: chatRoomId)
        .orderBy('created_at', descending: true)
        .startAfterDocument(lastDocument)
        .limit(limit)
        .get();

    final messages =
        snapshot.docs.map((doc) => _mapDocumentToMessage(doc)).toList();

    return {
      'messages': messages,
      'lastDoc': snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
    };
  }

  types.Message _mapDocumentToMessage(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return types.TextMessage(
      author: types.User(id: data['sender_id']),
      createdAt: data['created_at']?.millisecondsSinceEpoch,
      id: doc.id,
      text: data['message'],
    );
  }
}
