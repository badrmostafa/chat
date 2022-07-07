import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChatPage extends StatefulWidget {
  final String name;
  final String chatRoomId;
  final List<QueryDocumentSnapshot<Object?>> listUsers;
  const ChatPage(
      {required this.name,
      required this.listUsers,
      required this.chatRoomId,
      Key? key})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  @override
  void initState() {
    super.initState();
    sendNotifications();
  }

  void sendNotifications() {}

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void onSendMessage() async {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        'sendby': widget.listUsers
            .where((e) => auth.currentUser!.uid == e['uid'])
            .toList()
            .first['name'],
        'message': messageController.text,
        'time': FieldValue.serverTimestamp()
      };

      await firebaseFirestore
          .collection('users')
          .doc(widget.chatRoomId)
          .collection('chats')
          .add(messages);
      messageController.clear();
    } else {
      debugPrint('insert message');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.amber.shade500),
        backgroundColor: Colors.white10,
        title: Text(
          widget.name,
          style: const TextStyle(color: Colors.white70),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(),
              height: size.height / 1.25,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                  stream: firebaseFirestore
                      .collection('users')
                      .doc(widget.chatRoomId)
                      .collection('chats')
                      .orderBy('time', descending: false)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, i) {
                            Map<String, dynamic> map = snapshot.data!.docs[i]
                                .data() as Map<String, dynamic>;
                            return messages(size, map);
                          });
                    } else {
                      return Container();
                    }
                  }),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 45,
                      width: 300,
                      child: Container(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: TextFormField(
                          style: const TextStyle(color: Colors.white70),
                          textAlign: TextAlign.center,
                          controller: messageController,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.white30),
                            filled: true,
                            fillColor: Colors.white10,
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.amber.shade500)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)),
                            hintText: 'Write your message here',
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: onSendMessage,
                        child: CircleAvatar(
                            backgroundColor: Colors.white10,
                            child:
                                Icon(Icons.send, color: Colors.amber.shade500)))
                  ],
                ),
                const SizedBox(
                  height: 5,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> map) {
    return Container(
        padding: const EdgeInsets.only(top: 10),
        width: size.width,
        alignment: map['sendby'] ==
                widget.listUsers
                    .where((e) => e['uid'] == auth.currentUser!.uid)
                    .toList()
                    .first['name']
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 17),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: map['sendby'] ==
                      widget.listUsers
                          .where((user) => user['uid'] == auth.currentUser!.uid)
                          .toList()
                          .first['name']
                  ? const Color(0xFF723B8C)
                  : Colors.amber.shade900),
          child: Text(
            map['message'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ));
  }
}
