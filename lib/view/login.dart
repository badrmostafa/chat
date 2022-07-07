import 'package:chat_app/view/resetpassword_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/view/home.dart';
import 'package:chat_app/view/register.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  static const String loginRoute = 'login';
  const Login({Key? key}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final globalKey = GlobalKey<FormState>();

  var auth = FirebaseAuth.instance;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white12,
        centerTitle: true,
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 50),
        child: Form(
          key: globalKey,
          child: Column(
            children: [
              Container(
                  decoration: const BoxDecoration(),
                  height: 100,
                  width: 100,
                  child: Image.asset('images/chat.png')),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                style: const TextStyle(color: Colors.white70),
                controller: emailController,
                validator: (username) =>
                    username == null || !username.contains('@')
                        ? 'Insert Correct UserName'
                        : null,
                decoration: InputDecoration(
                    hintStyle: const TextStyle(color: Colors.white70),
                    fillColor: Colors.white12,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(color: Colors.amber.shade500, width: 2)),
                    prefixIcon: Icon(
                      Icons.mail,
                      color: Colors.amber.shade500,
                    ),
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                style: const TextStyle(color: Colors.white70),
                controller: passwordController,
                autofocus: false,
                validator: (password) => password == null || password.length < 6
                    ? 'Insert Correct Password'
                    : null,
                obscureText: true,
                decoration: InputDecoration(
                    hintStyle: const TextStyle(color: Colors.white70),
                    fillColor: Colors.white12,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.amber.shade500, width: 2),
                        borderRadius: BorderRadius.circular(15)),
                    prefixIcon:
                        Icon(Icons.vpn_key, color: Colors.amber.shade500),
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    )),
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
                  signIn(emailController.text, passwordController.text);
                },
                child: Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.amber.shade500),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context, ResetPasswordScreen.resetPageRoute);
                  },
                  child: Text('Forgot Password?',
                      style: TextStyle(color: Colors.amber.shade500))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Does not have account?',
                      style: TextStyle(color: Colors.white70)),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(Register.routeName);
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(color: Colors.amber.shade500),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void signIn(String email, String password) async {
    var state = globalKey.currentState as FormState;
    if (state.validate()) {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((userId) {
        Fluttertoast.showToast(msg: 'Login Successful');
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return const Home();
        }), (route) => false);
      }).catchError((e) {
        Fluttertoast.showToast(msg: 'This account not found in server');
      });
    }
  }
}
