import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

class Data {
  static Data instance = Data._singleton();

  Data._singleton();

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  List<UserModel> usersModel = [];
  List<UserModel> usersM = [];

  Stream<List<UserModel>> getAllUsers() async* {
    Stream<QuerySnapshot<Map<String, dynamic>>> streams =
        firebaseFirestore.collection('users').snapshots();
    await for (var stream in streams) {
      for (var doc in stream.docs) {
        usersModel.add(UserModel.fromMap(doc.data()));
      }
    }
  }
}
