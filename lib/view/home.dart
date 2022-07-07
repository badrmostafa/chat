import 'dart:io';

import 'package:chat_app/controller/methods.dart';
import 'package:chat_app/view/chatlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../model/user_model.dart';

class Home extends StatefulWidget {
  static const String homeRoute = 'home';
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  User? user = FirebaseAuth.instance.currentUser;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  UserModel userModel = UserModel();

  List<String> gender = ['Male', 'Female'];

  String valueGender = 'Male';

  int valueStatus = 1;

  GlobalKey globalKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  Data data = Data.instance;

  File? picture;

  String url = '';

  late TabController tabController;

  @override
  void initState() {
    super.initState();

    getData();

    tabController = TabController(length: 2, vsync: this);

    tabController.addListener(handleTabColor);
  }

  void handleTabColor() {
    setState(() {});
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white10,
          bottomNavigationBar: SizedBox(
            height: 50,
            child: TabBar(
              controller: tabController,
              indicatorColor: Colors.black12,
              labelColor: Colors.amber.shade500,
              unselectedLabelColor: Colors.white30,
              tabs: [
                Tab(
                  iconMargin: const EdgeInsets.only(top: 4),
                  text: 'Chats',
                  icon: Icon(Icons.chat_bubble,
                      color: tabController.index == 0
                          ? Colors.amber.shade500
                          : Colors.white30),
                ),
                Tab(
                  iconMargin: const EdgeInsets.only(top: 4),
                  text: 'Profile',
                  icon: Icon(Icons.account_circle,
                      color: tabController.index == 1
                          ? Colors.amber.shade500
                          : Colors.white30),
                ),
              ],
            ),
          ),
          body: Center(
            child: TabBarView(
              controller: tabController,
              children: [
                const Tab(
                  child: ChatGroup(),
                ),
                Tab(
                  child: profile(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<UserModel> getData() async {
    await firebaseFirestore
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      userModel = UserModel.fromMap(value.data());
      setState(() {});
    });
    return userModel;
  }

  Future<void> openDialog() async {
    nameController.text = userModel.name as String;
    ageController.text = userModel.age as String;
    valueGender = userModel.gender as String;
    valueStatus = userModel.status == 'Single' ? 1 : 2;
    await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
              child: Form(
                key: globalKey,
                child: AlertDialog(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.amber.shade500),
                  ),
                  content: Column(
                    children: [
                      TextFormField(
                        style: const TextStyle(color: Colors.white70),
                        controller: nameController,
                        validator: (name) => name == null || name.length < 3
                            ? 'Insert Correct Name'
                            : null,
                        decoration: InputDecoration(
                            fillColor: Colors.white12,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Colors.amber.shade500, width: 2)),
                            prefixIcon: Icon(
                              Icons.account_circle,
                              color: Colors.amber.shade500,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: 'Name'),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      TextFormField(
                        style: const TextStyle(color: Colors.white70),
                        controller: ageController,
                        validator: (age) =>
                            age == null || !RegExp(r'^[0-9]').hasMatch(age)
                                ? 'Insert Correct Age'
                                : null,
                        decoration: InputDecoration(
                            fillColor: Colors.white12,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Colors.amber.shade500, width: 2)),
                            prefixIcon: Icon(
                              Icons.account_circle,
                              color: Colors.amber.shade500,
                            ),
                            hintText: 'Age',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            )),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 5, bottom: 5),
                          child: DropdownButton(
                            dropdownColor: Colors.amber.shade700,
                            underline: DropdownButtonHideUnderline(
                              child: Container(),
                            ),
                            isExpanded: true,
                            items: gender.map((val) {
                              return DropdownMenuItem(
                                  value: val,
                                  child: Text(val,
                                      style: const TextStyle(
                                          color: Colors.white70)));
                            }).toList(),
                            value: valueGender,
                            onChanged: (dynamic str) {
                              setState(() {
                                valueGender = str;
                              });
                            },
                          ),
                        ),
                      ),
                      ListTile(
                        title: const Text(
                          'Single',
                          style: TextStyle(color: Colors.white70),
                        ),
                        leading: Radio(
                          fillColor:
                              MaterialStateProperty.all(Colors.amber.shade500),
                          value: 1,
                          groupValue: valueStatus,
                          onChanged: (int? val) {
                            setState(() {
                              valueStatus = val!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text(
                          'Married',
                          style: TextStyle(color: Colors.white70),
                        ),
                        leading: Radio(
                          fillColor:
                              MaterialStateProperty.all(Colors.amber.shade500),
                          value: 2,
                          groupValue: valueStatus,
                          onChanged: (int? val) {
                            setState(() {
                              valueStatus = val!;
                            });
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white12)),
                              onPressed: () {
                                var state = globalKey.currentState as FormState;
                                if (state.validate()) {
                                  editUser();
                                }
                              },
                              child: Text('Save',
                                  style:
                                      TextStyle(color: Colors.amber.shade500))),
                          const SizedBox(width: 2),
                          ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white12)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel',
                                  style:
                                      TextStyle(color: Colors.amber.shade500)))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  Widget profile() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              const SizedBox(
                width: 8,
              ),
              Text('Privacy',
                  style: TextStyle(color: Colors.amber.shade500, fontSize: 16)),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: const [
              SizedBox(
                width: 8,
              ),
              Text('Profile',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 30)),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.only(top: 10, left: 16, bottom: 10),
            decoration: const BoxDecoration(color: Colors.white10),
            child: Row(
              children: [
                Stack(children: [
                  ClipOval(
                    child: Align(
                      heightFactor: 0.5,
                      child: Container(
                        decoration: const BoxDecoration(),
                        height: 150,
                        width: 75,
                        child: FadeInImage(
                            placeholder: const AssetImage('images/spinner.gif'),
                            image: NetworkImage(userModel.urlImage ??
                                'https://firebasestorage.googleapis.com/v0/b/chat-app-585de.appspot.com/o/usersImages%2Fimage_icon1.png?alt=media&token=d70ac228-5bed-4532-ae46-eb5326fd4fab')),
                      ),
                    ),
                  ),
                  /*CircleAvatar(
                    backgroundImage: userModel.urlImage == null
                        ? null
                        : NetworkImage(userModel.urlImage!),
                    radius: 38,
                  )*/
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: GestureDetector(
                          onTap: imageCamera,
                          child: CircleAvatar(
                              backgroundColor: Colors.amber.shade500,
                              child: const Icon(Icons.add_a_photo_sharp,
                                  color: Colors.black)),
                        ),
                      ))
                ]),
                const SizedBox(
                  width: 5,
                ),
                Column(
                  children: [
                    Text('${userModel.name}',
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            fontWeight: FontWeight.bold))
                  ],
                ),
                const SizedBox(
                  width: 60,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: imageCamera,
                      child: CircleAvatar(
                          backgroundColor: Colors.white12,
                          child: Icon(Icons.camera_alt_sharp,
                              color: Colors.amber.shade500)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: openDialog,
                      child: CircleAvatar(
                          backgroundColor: Colors.white12,
                          child:
                              Icon(Icons.edit, color: Colors.amber.shade500)),
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              SizedBox(width: 12),
              Text('EMAIL ADDRESS', style: TextStyle(color: Colors.white38)),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            decoration: const BoxDecoration(color: Colors.white10),
            child: Row(
              children: [
                Text('${userModel.email}',
                    style: const TextStyle(color: Colors.white70, fontSize: 17))
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              SizedBox(width: 12),
              Text('AGE', style: TextStyle(color: Colors.white38)),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            decoration: const BoxDecoration(color: Colors.white10),
            child: Row(
              children: [
                Text('${userModel.age}',
                    style: const TextStyle(color: Colors.white70, fontSize: 17))
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              SizedBox(width: 12),
              Text('GENDER', style: TextStyle(color: Colors.white38)),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            decoration: const BoxDecoration(color: Colors.white10),
            child: Row(
              children: [
                Text('${userModel.gender}',
                    style: const TextStyle(color: Colors.white70, fontSize: 17))
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              SizedBox(width: 12),
              Text('STATUS', style: TextStyle(color: Colors.white38)),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            decoration: const BoxDecoration(color: Colors.white10),
            child: Row(
              children: [
                Text('${userModel.status}',
                    style: const TextStyle(color: Colors.white70, fontSize: 17))
              ],
            ),
          ),
        ]),
      ),
    );
  }

  void imageCamera() async {
    var imagePicker = ImagePicker();
    var image = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      picture = File(image!.path);
    });
    var ref = FirebaseStorage.instance
        .ref()
        .child('usersImages')
        .child('${userModel.name}.png');
    var uploadImage = await ref.putFile(picture!);
    String url = await uploadImage.ref.getDownloadURL();

    firebaseFirestore
        .collection('users')
        .doc(user!.uid)
        .update({'urlImage': url}).then((value) {
      getData();
    });
  }

  Future<void> editUser() async {
    userModel.userId = user!.uid;
    userModel.email = user!.email;
    userModel.name = nameController.text;
    userModel.age = ageController.text;
    userModel.gender = valueGender;
    userModel.status = valueStatus == 1 ? 'Single' : 'Married';

    await firebaseFirestore
        .collection('users')
        .doc(user!.uid)
        .update(userModel.toMap());
    Fluttertoast.showToast(msg: 'Data Is Updated Successfully');
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
        (route) => false);
  }
}
