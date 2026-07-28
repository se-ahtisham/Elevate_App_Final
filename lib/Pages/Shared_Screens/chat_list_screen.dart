import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/chat_model.dart';
import 'package:elevate_app/Database/Online_Database/auth_provider.dart';
import 'package:elevate_app/Database/Online_Database/chat_service.dart';
import 'package:elevate_app/Pages/Shared_Screens/chat_room_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final myID = authState.jobSeeker?.jobSeekerID ??
        authState.company?.companyID ??
        authState.admin?.adminID ??
        '';

    final chatService = ChatService();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: myID.isEmpty
          ? const Center(child: Text('Please log in to view messages'))
          : StreamBuilder<List<ChatModel>>(
              stream: chatService.chatsStream(myID),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                }

                final chats = snapshot.data ?? [];

                if (chats.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.forum_outlined,
                            size: 60, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          'No conversations yet',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Message a job seeker or company\nfrom their profile page.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: chats.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: Colors.grey.shade100,
                    indent: 74,
                  ),
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    // Find the other user
                    final otherID = chat.participants
                        .firstWhere((id) => id != myID, orElse: () => '');
                    final otherName =
                        chat.participantNames[otherID] ?? 'Unknown';
                    final otherAvatar =
                        chat.participantAvatars[otherID] ?? '';
                    final isLastMine = chat.lastSenderID == myID;
                    final timeStr = chat.lastMessage.isEmpty
                        ? ''
                        : _formatTime(chat.lastMessageTime);

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      leading: CircleAvatar(
                        radius: 26,
                        backgroundImage: otherAvatar.isNotEmpty
                            ? NetworkImage(otherAvatar)
                            : null,
                        backgroundColor: Colors.grey.shade200,
                        child: otherAvatar.isEmpty
                            ? Text(
                                otherName.isNotEmpty
                                    ? otherName[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                              )
                            : null,
                      ),
                      title: Text(
                        otherName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: chat.lastMessage.isEmpty
                          ? Text(
                              'Start a conversation',
                              style: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 13),
                            )
                          : Text(
                              '${isLastMine ? "You: " : ""}${chat.lastMessage}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 13),
                            ),
                      trailing: timeStr.isNotEmpty
                          ? Text(
                              timeStr,
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 11,
                              ),
                            )
                          : null,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatRoomScreen(
                              chatID: chat.chatID,
                              otherUserName: otherName,
                              otherUserAvatar: otherAvatar,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) return DateFormat('h:mm a').format(dt);
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return DateFormat('EEE').format(dt);
    return DateFormat('MMM d').format(dt);
  }
}
