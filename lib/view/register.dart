import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../view/home.dart';

class Register extends StatefulWidget {
  static const String routeName = 'register';

  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  List<String> gender = ['Male', 'Female'];

  String genderVal = 'Male';

  int number = 1;

  bool checkBox = false;

  GlobalKey globalKey = GlobalKey<FormState>();

  RegExp regExp = RegExp(r'^[0-9]');
  String _password = '';

  var auth = FirebaseAuth.instance;

  File? image;

  String? url;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    ageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.amber.shade500),
        backgroundColor: Colors.white12,
        title: const Text('Register Now'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(left: 10, bottom: 10, right: 10, top: 15),
        child: Form(
          key: globalKey,
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.tealAccent[700],
                    backgroundImage: image == null ? null : FileImage(image!),
                    radius: 50,
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          takeImage();
                        },
                        child: const CircleAvatar(
                            backgroundColor: Colors.amber,
                            child: Icon(Icons.camera_alt_sharp,
                                color: Colors.black)),
                      ))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                style: const TextStyle(color: Colors.white70),
                controller: nameController,
                validator: (name) => name == null || name.length < 3
                    ? 'Insert Correct Name'
                    : null,
                decoration: InputDecoration(
                    fillColor: Colors.white12,
                    filled: true,
                    hintStyle: const TextStyle(color: Colors.white70),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.amber.shade500, width: 2),
                        borderRadius: BorderRadius.circular(15)),
                    prefixIcon: Icon(
                      Icons.account_circle,
                      color: Colors.amber.shade500,
                    ),
                    hintText: 'Enter Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                style: const TextStyle(color: Colors.white70),
                controller: emailController,
                validator: (email) => email == null || !email.contains('@')
                    ? 'Insert Correct Email'
                    : null,
                decoration: InputDecoration(
                    fillColor: Colors.white12,
                    filled: true,
                    hintStyle: const TextStyle(color: Colors.white70),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.amber.shade500, width: 2),
                        borderRadius: BorderRadius.circular(15)),
                    prefixIcon: Icon(
                      Icons.mail,
                      color: Colors.amber.shade500,
                    ),
                    hintText: 'Enter Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                style: const TextStyle(color: Colors.white70),
                controller: ageController,
                validator: (age) =>
                    age == null || !(regExp.hasMatch(age)) || age.length > 2
                        ? 'Insert Correct Age'
                        : null,
                decoration: InputDecoration(
                    fillColor: Colors.white12,
                    filled: true,
                    hintStyle: const TextStyle(color: Colors.white70),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.amber.shade500, width: 2),
                        borderRadius: BorderRadius.circular(15)),
                    prefixIcon: Icon(
                      Icons.account_circle,
                      color: Colors.amber.shade500,
                    ),
                    hintText: 'Enter Age',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
              const SizedBox(
                height: 8,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 5, bottom: 5),
                  child: DropdownButton(
                      dropdownColor: Colors.amber.shade500,
                      underline: DropdownButtonHideUnderline(
                        child: Container(),
                      ),
                      isExpanded: true,
                      items: gender
                          .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: const TextStyle(color: Colors.white70),
                              )))
                          .toList(),
                      value: genderVal,
                      onChanged: (dynamic value) {
                        setState(() {
                          genderVal = value;
                        });
                      }),
                ),
              ),
              ListTile(
                  title: const Text(
                    'Single',
                    style: TextStyle(
                        color: Colors.white70, fontWeight: FontWeight.w500),
                  ),
                  leading: Radio(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.amber.shade500),
                      value: 1,
                      groupValue: number,
                      onChanged: (dynamic value) {
                        setState(() {
                          number = value;
                        });
                      })),
              ListTile(
                  title: const Text(
                    'Married',
                    style: TextStyle(
                        color: Colors.white70, fontWeight: FontWeight.w500),
                  ),
                  leading: Radio(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.amber.shade500),
                      value: 2,
                      groupValue: number,
                      onChanged: (dynamic value) {
                        setState(() {
                          number = value;
                        });
                      })),
              TextFormField(
                style: const TextStyle(color: Colors.white70),
                controller: passwordController,
                validator: (password) => password == null || password.length < 6
                    ? 'Insert Correct Password'
                    : null,
                onChanged: (pass) => _password = pass,
                obscureText: true,
                decoration: InputDecoration(
                    fillColor: Colors.white12,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.amber.shade500, width: 2),
                        borderRadius: BorderRadius.circular(15)),
                    prefixIcon: Icon(
                      Icons.vpn_key,
                      color: Colors.amber.shade500,
                    ),
                    hintText: 'Enter Password',
                    hintStyle: const TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                style: const TextStyle(color: Colors.white70),
                validator: (password) =>
                    password != _password ? 'Confirm Password Invalid' : null,
                obscureText: true,
                decoration: InputDecoration(
                    fillColor: Colors.white12,
                    filled: true,
                    hintStyle: const TextStyle(color: Colors.white70),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.amber.shade500, width: 2),
                        borderRadius: BorderRadius.circular(15)),
                    prefixIcon: Icon(
                      Icons.vpn_key,
                      color: Colors.amber.shade500,
                    ),
                    hintText: 'Enter Confirm Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
              FormField(
                validator: (check) => checkBox ? null : '',
                builder: (state) {
                  return Column(
                    children: [
                      ListTile(
                          title: const Text(
                            'I agree to the terms and condition',
                            style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w500),
                          ),
                          leading: Checkbox(
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => Colors.amber.shade500),
                            value: checkBox,
                            onChanged: (val) {
                              setState(() {
                                checkBox = val!;
                              });
                            },
                          )),
                      state.errorText == null
                          ? const Text('')
                          : Text(
                              'You Need To Accept Terms',
                              style: TextStyle(
                                  color: Colors.amber.shade500, fontSize: 12),
                            )
                    ],
                  );
                },
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white12),
                      elevation: MaterialStateProperty.all<double>(7),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)))),
                  onPressed: () {
                    signUp(emailController.text, passwordController.text);
                  },
                  child: Text(
                    'Sign up',
                    style: TextStyle(color: Colors.amber.shade500),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    var keyState = globalKey.currentState as FormState;
    if (keyState.validate()) {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => saveDataToFirebase())
          .catchError((parameter) {
        Fluttertoast.showToast(
            msg: 'Email Address May Be in use by another account.');
      });
    }
  }

  void saveDataToFirebase() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;
    UserModel userModel = UserModel();
    if (image != null) {
      var ref = FirebaseStorage.instance
          .ref()
          .child('usersImages')
          .child('${nameController.text}.jpg');
      var uploadTask = await ref.putFile(image!);
      url = await uploadTask.ref.getDownloadURL();
    } else {
      url =
          'https://firebasestorage.googleapis.com/v0/b/chat-app-585de.appspot.com/o/usersImages%2Fimage_icon1.png?alt=media&token=d70ac228-5bed-4532-ae46-eb5326fd4fab';
    }

    userModel.userId = user!.uid;
    userModel.name = nameController.text;
    userModel.email = user.email;
    userModel.age = ageController.text;
    userModel.gender = genderVal;
    userModel.status = number == 1 ? 'Single' : 'Married';
    userModel.urlImage = url;

    await firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .set(userModel.toMap());

    Fluttertoast.showToast(msg: 'Account created successfully');
    if (!mounted) return;
    await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
        (route) => false);
  }

  void takeImage() async {
    var imagePicker = ImagePicker();
    final picture = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      image = File(picture!.path);
    });
  }
}
