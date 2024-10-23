import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sage_app/core/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sage_app/features/chat/screens/chat.dart';
import 'package:sage_app/core/constants/string_manager.dart';
import 'package:sage_app/features/auth/invite/view/invite_code_screen.dart';
import 'package:sage_app/features/anonymous_chat/models/chat_room_model.dart';
import 'package:sage_app/features/anonymous_chat/screens/anonymous_requests.dart';

class TeacherView extends StatefulWidget {
  const TeacherView({super.key});

  @override
  State<TeacherView> createState() => _TeacherViewState();
}

class _TeacherViewState extends State<TeacherView> {
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
              Colors.grey[900]!,
              Colors.black,
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
              .where('teacher_id', isEqualTo: UserSession.instance.uid)
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
                Row(
                  children: [
                    Text(
                      '  Chats',
                      style: TextStyle(
                          fontSize: 36,
                          color: Colors.grey.shade200,
                          fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AnonymousRequestsView(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.sos,
                        size: 40,
                        color: Colors.grey.shade200,
                      ),
                    ),
                    const SizedBox(width: 8)
                  ],
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
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 25,
                              child: Image.asset(
                                StringManager.personIcon,
                                height: 32,
                              ),
                            ),
                            title: Text(
                              chatRoom.roomName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey.shade200,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade900,
        onPressed: () {
          showCupertinoDialog<void>(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
              title: const Text('Logout'),
              content: const Text(
                "Are you sure, you want to logout?",
              ),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                    FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const InviteCodeScreen(),
                        ),
                        (Route<dynamic> route) => false);
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          );
        },
        child: const Icon(
          Icons.logout,
          color: Colors.white,
        ),
      ),
    );
  }
}
