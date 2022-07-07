import 'package:chat_app/view/resetpassword_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/view/register.dart';

import 'view/home.dart';

import 'view/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(routes: {
      Register.routeName: (context) => const Register(),
      Home.homeRoute: (context) => const Home(),
      Login.loginRoute: (context) => const Login(),
      ResetPasswordScreen.resetPageRoute: (context) =>
          const ResetPasswordScreen()
    }, home: const Login());
  }
}
