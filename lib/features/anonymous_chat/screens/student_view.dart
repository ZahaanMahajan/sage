import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:sage_app/core/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sage_app/features/chat/screens/chat.dart';
import 'package:sage_app/features/anonymous_chat/models/chat_room_model.dart';

class StudentView extends StatefulWidget {
  const StudentView({super.key});

  @override
  State<StudentView> createState() => _StudentViewState();
}

class _StudentViewState extends State<StudentView> {
  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd MMM yy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.teal.shade100,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
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

            if (!snapshot.hasData) {
              return const Center(child: Text('No chats available.'));
            }

            var chatRooms = snapshot.data!.docs;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 70),
                Text(
                  '  Chats',
                  style: TextStyle(
                      fontSize: 36,
                      color: Colors.grey.shade900,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  itemCount: chatRooms.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          margin: const EdgeInsets.only(
                              bottom: 8, left: 8, right: 8),
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const CircleAvatar(
                              backgroundColor: Colors.teal,
                              backgroundImage:
                                  AssetImage('assets/images/sage.png'),
                              radius: 25,
                            ),
                            title: Text(
                              chatRoom.roomName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
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
                                    token: chatRoom.studentToken,
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
