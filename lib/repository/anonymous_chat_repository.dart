// ignore_for_file: unused_field

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnonymousChatRepository {
  //* =============== Variables  =============== *//
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> setRequestFlagToTrue(String chatRoomId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('chat_room')
          .doc(chatRoomId)
          .get();

      if (doc.exists) {
        log('Document exists, updating now...');
        await FirebaseFirestore.instance
            .collection('chat_room')
            .doc(chatRoomId)
            .update({'accepted': true});
        log('Request flag set to true for Chat Room ID: $chatRoomId');
      } else {
        log('Document with Chat Room ID $chatRoomId not found.');
      }
    } catch (e) {
      log('Error while updating request flag for Chat Room ID $chatRoomId: $e');
    }
  }
}
