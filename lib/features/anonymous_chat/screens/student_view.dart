import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:sage_app/core/models/user.dart';
import 'package:sage_app/core/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sage_app/features/anonymous_chat/models/chat_room_model.dart';
import 'package:sage_app/features/chat/screens/chat.dart';

class StudentView extends StatefulWidget {
  const StudentView({super.key});

  @override
  State<StudentView> createState() => _StudentViewState();
}

class _StudentViewState extends State<StudentView> {
  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chats',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chat_room')
            .where('accepted', isEqualTo: true)
            .where('gender', isEqualTo: UserSession.instance.gender ?? 'male')
            .where('student_id', isEqualTo: UserSession.instance.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading chats.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No chats available.'));
          }

          var chatRooms = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              var chatRoom = ChatRoomModel.fromMap(
                chatRooms[index].data() as Map<String, dynamic>,
              );
              var lastMessage = (chatRoom.lastMessage == '')
                  ? 'No messages yet'
                  : chatRoom.lastMessage;

              return Stack(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: btnBg.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(
                        backgroundColor: btnBg,
                        backgroundImage: AssetImage('assets/images/sage.png'),
                        radius: 25,
                      ),
                      title: Text(
                        chatRoom.roomName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        lastMessage,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        formatTimestamp(chatRoom.updatedAt),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              chatRoomId: chatRoom.chatRoomId,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  (chatRoom.unreadMsgCount != 0)
                      ? Positioned(
                          top: 8,
                          right: 16,
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${chatRoom.unreadMsgCount}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink()
                ],
              );
            },
          );
        },
      ),
    );
  }
}