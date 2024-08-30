import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:chat_app/widgets/chat_bubble_friend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  CollectionReference messages =
      FirebaseFirestore.instance.collection("messages");

  TextEditingController textController = TextEditingController();

  final _scrollController = ScrollController();

  List<MessageModel>? messagesList;

  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;

    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<MessageModel> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(
              MessageModel.fromJson(snapshot.data!.docs[i]),
            );
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xff2B475E),
              centerTitle: true,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 50,
                    child: Image.asset("assets/images/scholar.png"),
                  ),
                  const Text(
                    " chat",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      if (messagesList[index].email == email) {
                        return ChatBubble(message: messagesList[index]);
                      } else {
                        return ChatBubbleFriend(message: messagesList[index]);
                      }
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TextField(
                    controller: textController,
                    onSubmitted: (data) {
                      messages.add(
                        {
                          'message': data,
                          'createdAt': DateTime.now(),
                          'email': email,
                        },
                      );
                      textController.clear();
                      _scrollController.animateTo(0,
                          duration: const Duration(seconds: 1),
                          curve: Curves.fastOutSlowIn);
                    },
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        onTap: () {
                          if (textController.text.isNotEmpty) {
                            messages.add(
                              {
                                'message': textController.text,
                                'createdAt': DateTime.now(),
                                'email': email,
                              },
                            );
                            textController.clear();
                            _scrollController.animateTo(0,
                                duration: const Duration(seconds: 1),
                                curve: Curves.fastOutSlowIn);
                          }
                        },
                        child: const Icon(Icons.send),
                      ),
                      iconColor: const Color(0xff2B475E),
                      hintText: "Type a Message",
                      border: const OutlineInputBorder(),
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
