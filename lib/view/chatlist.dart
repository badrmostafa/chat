import 'package:chat_app/view/chat_page.dart';
import 'package:chat_app/view/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ChatGroup extends StatefulWidget {
  const ChatGroup({Key? key}) : super(key: key);
  @override
  State<ChatGroup> createState() => _ChatGroupState();
}

class _ChatGroupState extends State<ChatGroup> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  static ValueNotifier<String> name = ValueNotifier<String>('');

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2[0].toLowerCase().codeUnits[0]) {
      return '$user1$user2';
    } else {
      return '$user2$user1';
    }
  }

  bool isLoading = false;

  Widget changeLoadState(bool val) {
    setState(() {
      isLoading = val;
    });
    return const Text('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Chats',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 35,
                      ),
                    ),
                    const SizedBox(
                      width: 210,
                    ),
                    GestureDetector(
                        onTap: () {
                          logout();
                        },
                        child: Icon(Icons.logout_outlined,
                            color: Colors.amber.shade500))
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 30,
                  child: TextFormField(
                    style: const TextStyle(color: Colors.white70),
                    onChanged: (val) {
                      setState(() {
                        name.value = val;
                      });
                    },
                    textAlignVertical: TextAlignVertical.bottom,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white10)),
                        filled: true,
                        fillColor: Colors.white10,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.white30),
                        hintText: 'Search',
                        hintStyle: const TextStyle(color: Colors.white30)),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Broadcast Lists',
                      style:
                          TextStyle(color: Colors.amber.shade500, fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Divider(
                  color: Colors.grey.shade900,
                ),
                const SizedBox(height: 6),
                StreamBuilder<QuerySnapshot>(
                    stream: firebaseFirestore.collection('users').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<QueryDocumentSnapshot<Object?>> data =
                            snapshot.data!.docs;
                        return ValueListenableBuilder(
                          valueListenable: name,
                          builder: (context, newVal, child) {
                            data = data
                                .where((e) => e['name']
                                    .toString()
                                    .toLowerCase()
                                    .contains(newVal.toString().toLowerCase()))
                                .toList();
                            return ListView.builder(
                                controller:
                                    ScrollController(keepScrollOffset: true),
                                shrinkWrap: true,
                                itemCount: data.length,
                                itemBuilder: (context, i) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          String user1 = data
                                              .where((e) =>
                                                  e['uid'] ==
                                                  auth.currentUser!.uid)
                                              .toList()
                                              .first['name'];
                                          String user2 = data[i]['name'];
                                          String roomId =
                                              chatRoomId(user1, user2);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ChatPage(
                                                  name: user2,
                                                  listUsers: data,
                                                  chatRoomId: roomId,
                                                ),
                                              ));
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(),
                                          child: Row(
                                            children: [
                                              ClipOval(
                                                child: Align(
                                                  heightFactor: 0.4,
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(),
                                                    height: 150,
                                                    width: 61,
                                                    child: FadeInImage(
                                                        placeholder:
                                                            const AssetImage(
                                                                'images/spinner.gif'),
                                                        image: NetworkImage(
                                                            data[i]
                                                                ['urlImage'])),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 30,
                                              ),
                                              Text(
                                                '${data[i]['name']}',
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.white70,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(color: Colors.grey.shade900)
                                    ],
                                  );
                                });
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      } else {
                        return Column(children: const [
                          SizedBox(
                            height: 170,
                          ),
                          CircularProgressIndicator()
                        ]);
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void logout() {
    Navigator.popAndPushNamed(context, Login.loginRoute);
  }
}
