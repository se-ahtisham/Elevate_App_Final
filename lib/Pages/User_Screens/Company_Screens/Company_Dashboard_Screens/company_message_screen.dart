import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/circle_icon_button.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/message.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/user_description_short.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:flutter/material.dart';
import 'package:elevate_app/Database/Online_Database/auth_service.dart';

class CompanyMessageScreen extends StatefulWidget {
  final String? receiverId;
  final String? receiverName;
  final String? receiverImage;
  
  const CompanyMessageScreen({
    super.key, 
    this.receiverId, 
    this.receiverName, 
    this.receiverImage,
  });

  @override
  State<CompanyMessageScreen> createState() => _CompanyMessageScreenState();
}

class _CompanyMessageScreenState extends State<CompanyMessageScreen> {
  final TextEditingController messageController = TextEditingController();
  final AuthService _authService = AuthService();
  
  late String currentUserId;
  late String chatId;

  @override
  void initState() {
    super.initState();
    currentUserId = _authService.currentUser?.uid ?? '';
    final String rId = widget.receiverId ?? 'unknown';
    chatId = currentUserId.compareTo(rId) > 0 
        ? '${currentUserId}_$rId' 
        : '${rId}_$currentUserId';
  }

  void _sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    messageController.clear();

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'senderId': currentUserId,
      'receiverId': widget.receiverId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
              child: Row(
                children: [
                  CircleIconButton(
                    iconData: Icons.arrow_back,
                    circleSize: 45,
                    iconSize: 20,
                    circleColor: const Color.fromARGB(255, 51, 51, 51),
                    iconColor: const Color.fromARGB(255, 238, 238, 238),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 226, 226, 226),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: UserDescriptionShort(
                          imageURL: widget.receiverImage != null && widget.receiverImage!.isNotEmpty
                              ? widget.receiverImage!
                              : "lib/Resources/Images/Profile_Images/default_profile.png",
                          name: widget.receiverName ?? "User",
                          shortDescription: "Chat",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(chatId)
                    .collection('messages')
                    .orderBy('timestamp', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return const Center(child: Text("No messages yet."));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      final bool isMe = data['senderId'] == currentUserId;
                      return Message(
                        text: data['text'] ?? '',
                        isMe: isMe,
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, bottom: 50.0),
              child: Row(
                children: [
                  Container(
                    width: 350,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 233, 233, 233),
                      border: Border.all(color: const Color.fromARGB(255, 75, 75, 75),),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CustomTextField(
                        controller: messageController,
                        hintText: "Type message...",
                        cursorColor: Colors.black,
                        underlineColor: Colors.transparent,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleIconButton(
                    iconData: Icons.send,
                    circleSize: 45,
                    circleColor: Colors.black,
                    iconColor: Colors.white,
                    onTap: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
