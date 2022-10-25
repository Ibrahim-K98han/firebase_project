import 'package:firebase_project/provider/chat_room_provider.dart';
import 'package:firebase_project/widgets/message_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatRoomPage extends StatefulWidget {
  static const String routeName = '/chat_room_page';

  const ChatRoomPage({Key? key}) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final msgController = TextEditingController();
  bool isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<ChatRoomProvider>(context, listen: false)
          .getAllChatRoomMessages();
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ChatRoomProvider>(
        builder: (context, provider, _) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: provider.msgList.length,
                itemBuilder: (context, index) {
                  final msg = provider.msgList[index];
                  return MessageItem(messageModel: msg);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: msgController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        provider.addMsg(msgController.text);
                        msgController.clear();
                      },
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).primaryColor,
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
