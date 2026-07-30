// Legacy stub kept for backward compatibility with any existing call sites
// that still construct ComapanyUserMessage(receiverId:, receiverName:,
// receiverImage:). Internally it now resolves/creates a chat via
// ChatService and opens the same shared ChatRoomScreen used everywhere
// else in the app, instead of the old (now removed) CompanyMessageScreen.
import 'package:elevate_app/Database/Online_Database/auth_service.dart';
import 'package:elevate_app/Database/Online_Database/chat_service.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Pages/Shared_Screens/chat_room_screen.dart';
import 'package:flutter/material.dart';

class ComapanyUserMessage extends StatelessWidget {
  final String receiverId;
  final String receiverName;
  final String receiverImage;

  const ComapanyUserMessage({
    super.key,
    required this.receiverId,
    required this.receiverName,
    required this.receiverImage,
  });

  Future<String?> _resolveChatID() async {
    final companyID = AuthService().currentUser?.uid ?? '';
    if (companyID.isEmpty) return null;

    final company = await FirebaseService().getCompany(companyID);
    final myName = company?.companyName ?? 'Company';
    final myAvatar = company?.logo ?? '';

    final otherAvatar = receiverImage.isNotEmpty
        ? receiverImage
        : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(receiverName)}&background=random&color=fff&size=128';

    return ChatService().getOrCreateChat(
      myID: companyID,
      myName: myName,
      myAvatar: myAvatar,
      otherID: receiverId,
      otherName: receiverName,
      otherAvatar: otherAvatar,
    );
  }

  @override
  Widget build(BuildContext context) {
    final otherAvatar = receiverImage.isNotEmpty
        ? receiverImage
        : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(receiverName)}&background=random&color=fff&size=128';

    return FutureBuilder<String?>(
      future: _resolveChatID(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator(color: Colors.black)),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Could not open chat.'),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          );
        }

        return ChatRoomScreen(
          chatID: snapshot.data!,
          otherUserName: receiverName,
          otherUserAvatar: otherAvatar,
        );
      },
    );
  }
}
