import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:perso/helper/helperfunction.dart';
import 'package:perso/services/auth.dart';
import 'package:perso/services/database.dart';
import 'package:perso/widgets/widgets.dart';
import 'package:perso/views/chat_screen.dart';


class SignIn extends StatefulWidget {
  final Function toggle;

  const SignIn(this.toggle, {Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController emailtextEditingController = TextEditingController();
  late QuerySnapshot<Map<String, dynamic>> snapshotUserInfo;
  TextEditingController passwordtextEditingController = TextEditingController();
  bool isLoading = false;

  signIn() {
    if (formKey.currentState!.validate()) {
      HelperFunctions.saveUserEmailSharedPreference(
          emailtextEditingController.text);
      databaseMethods
          .getUserByEmail(emailtextEditingController.text)
          .then((val) {
        snapshotUserInfo = val;
        HelperFunctions.saveUserNameSharedPreference(
            snapshotUserInfo.docs[0].data()["name"]);
      });
      setState(() {
        isLoading = true;
      });

      authMethods
          .signInWithEmailAndPassword(emailtextEditingController.text,
              passwordtextEditingController.text)
          .then((val) {
        if (val != null) {
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const ChatRoom()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.blue.shade300,
            height: MediaQuery.of(context).size.height - 50,
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        cursorColor: Colors.amber,
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val!)
                              ? null
                              : "Enter correct email";
                        },
                        controller: emailtextEditingController,
                        style: const TextStyle(color: Colors.black87),
                        decoration: const InputDecoration(
                            hintText: "Enter Email",
                            hintStyle:
                                TextStyle(color: Color.fromARGB(255, 20, 8, 8)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white))),
                      ),
                      TextFormField(
                        cursorColor: Colors.amber,
                        obscureText: true,
                        validator: (val) {
                          return val!.length > 6
                              ? null
                              : "Provide Password greater then 6 characters";
                        },
                        controller: passwordtextEditingController,
                        style: const TextStyle(color: Colors.black87),
                        decoration: const InputDecoration(
                            hintText: "Enter Password",
                            hintStyle:
                                TextStyle(color: Color.fromARGB(255, 20, 8, 8)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white))),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: const Text(
                      "Forget Password?",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () {
                    signIn();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Color(0xff007EF4), Color(0xff2A75BC)]),
                        borderRadius: BorderRadius.circular(30)),
                    child: const Text("Sign in",
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: const Text("Sign in with google",
                      style: TextStyle(color: Colors.black87, fontSize: 17)),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have a account? ",
                      style: mediumTextField(),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.toggle();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          "Register now",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 50,
                )
              ]),
            ),
          ),
        ));
  }
}
