import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:sage_app/core/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sage_app/features/chat/screens/chat.dart';
import 'package:sage_app/repository/anonymous_chat_repository.dart';
import 'package:sage_app/features/anonymous_chat/models/chat_room_model.dart';
import 'package:sage_app/features/anonymous_chat/cubit/anonymous_chat_cubit.dart';

class AnonymousRequestsView extends StatefulWidget {
  const AnonymousRequestsView({super.key});

  @override
  State<AnonymousRequestsView> createState() => _AnonymousRequestsViewState();
}

class _AnonymousRequestsViewState extends State<AnonymousRequestsView> {
  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AnonymousChatRepository(),
      child: BlocProvider(
        create: (context) => AnonymousChatCubit(),
        child: BlocConsumer<AnonymousChatCubit, AnonymousChatState>(
          listener: (context, state) {
            if (state is SetRequestFlagToTrueSuccess) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ChatScreen(chatRoomId: state.chatRoomID, token: ''),
                ),
              );
            }
          },
          builder: (context, state) {
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
                      .where('accepted', isEqualTo: false)
                      .where('gender',
                          isEqualTo: UserSession.instance.gender ?? 'male')
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
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Anonymous Requests',
                              style: TextStyle(
                                fontSize: 28,
                                color: Colors.grey.shade200,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ListView.builder(
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          itemCount: chatRooms.length,
                          itemBuilder: (context, index) {
                            var chatRoom = ChatRoomModel.fromMap(
                              chatRooms[index].data() as Map<String, dynamic>,
                            );

                            return Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.grey.shade200,
                                      radius: 25,
                                      child: const Icon(
                                        CupertinoIcons.person_fill,
                                        size: 30,
                                      ),
                                    ),
                                    title: Text(
                                      chatRoom.roomName,
                                      style: TextStyle(
                                        color: Colors.grey.shade200,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 16,
                                      ),
                                    ),
                                    subtitle: Text(
                                      formatTimestamp(chatRoom.createdAt),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    trailing: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: const CircleBorder()),
                                      onPressed: () {
                                        context
                                            .read<AnonymousChatCubit>()
                                            .setRequestFlagToTrue(
                                                chatRoom.chatRoomId);
                                      },
                                      child: const Icon(
                                        Icons.done_outline_rounded,
                                      ),
                                    ),
                                    onTap: () {
                                      // Handle the details of the Query
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: displayFormattedSummary(
                                              chatRoom.summary,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
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
          },
        ),
      ),
    );
  }

  Widget displayFormattedSummary(String summary) {
    // Split the summary by newlines to make it more readable
    List<String> summaryLines = summary.split('\n');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: summaryLines.map((line) {
          if (line.trim().isEmpty) {
            return const SizedBox(height: 10.0);
          }
          return Text(
            line,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black87,
              fontWeight: line.startsWith('Conversation Summary') ||
                      line.startsWith('Student Description')
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          );
        }).toList(),
      ),
    );
  }
}
