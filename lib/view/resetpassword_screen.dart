import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String resetPageRoute = 'reset';
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  GlobalKey globalKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return resetPage();
  }

  Widget resetPage() {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.amber.shade500),
            centerTitle: true,
            backgroundColor: Colors.white10,
            title: const Text('Reset Password')),
        body: Form(
          key: globalKey,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Recieve an email to\nreset your password',
                    style: TextStyle(color: Colors.white70)),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: emailController,
                  validator: (email) {
                    if (email == null) {
                      return 'Must insert email';
                    } else if (!email.contains('@')) {
                      return 'Must insert valid email';
                    } else {
                      return null;
                    }
                  },
                  autofocus: false,
                  style: const TextStyle(color: Colors.white70),
                  decoration: InputDecoration(
                    fillColor: Colors.white12,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.amber.shade500)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    prefixIcon: Icon(Icons.email, color: Colors.amber.shade500),
                    hintText: 'Email',
                    hintStyle: const TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        onPrimary: Colors.white70,
                        primary: Colors.white12,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15)),
                    onPressed: () {
                      var state = globalKey.currentState as FormState;
                      if (state.validate()) {
                        resetPassword(emailController.text);
                      }
                    },
                    icon: Icon(Icons.email_outlined,
                        color: Colors.amber.shade500),
                    label: const Text('Reset Password'))
              ],
            ),
          ),
        ));
  }

  void resetPassword(String email) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(msg: 'Password reset email sent');
      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(msg: error.message!);
      Navigator.of(context).pop();
    }
  }
}
