import 'package:flutter/material.dart';
import 'package:perso/helper/helperfunction.dart';
import 'package:perso/services/auth.dart';
import 'package:perso/services/database.dart';
import 'package:perso/views/chat_screen.dart';
import 'package:perso/widgets/widgets.dart';

class MySignUp extends StatefulWidget {
  final Function toggle;

  const MySignUp(this.toggle, {Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MySignUpState createState() => _MySignUpState();
}

class _MySignUpState extends State<MySignUp> {
  bool isLoading = false;
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  final formKey = GlobalKey<FormState>();
  TextEditingController userNametextEditingController = TextEditingController();

  TextEditingController emailtextEditingController = TextEditingController();

  TextEditingController passwordtextEditingController = TextEditingController();

  signMeUp() {
    if (formKey.currentState!.validate()) {
      Map<String, String> userInfoMap = {
        "name": userNametextEditingController.text,
        "email": emailtextEditingController.text
      };
      HelperFunctions.saveUserEmailSharedPreference(
          emailtextEditingController.text);
      HelperFunctions.saveUserEmailSharedPreference(
          userNametextEditingController.text);
      setState(() {
        isLoading = true;
      });
      authMethods
          .signUpWithEmailAndPassword(emailtextEditingController.text,
              passwordtextEditingController.text)
          .then((val) {
        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const ChatRoom()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
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
                                return val!.isEmpty || val.length < 2
                                    ? "Field requried"
                                    : null;
                              },
                              controller: userNametextEditingController,
                              style: simpleTextField(),
                              decoration: const InputDecoration(
                                  hintText: "Enter Username",
                                  hintStyle: TextStyle(
                                      color: Color.fromARGB(255, 20, 8, 8)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white))),
                            ),
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
                              style: simpleTextField(),
                              decoration: const InputDecoration(
                                  hintText: "Enter Email",
                                  hintStyle: TextStyle(
                                      color: Color.fromARGB(255, 20, 8, 8)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white))),
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
                              style: simpleTextField(),
                              decoration: const InputDecoration(
                                  hintText: "Enter Password",
                                  hintStyle: TextStyle(
                                      color: Color.fromARGB(255, 20, 8, 8)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white))),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
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
                          signMeUp();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [
                                Color(0xff007EF4),
                                Color(0xff2A75BC)
                              ]),
                              borderRadius: BorderRadius.circular(30)),
                          child: const Text("Sign Up",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16)),
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
                            style:
                                TextStyle(color: Colors.black87, fontSize: 17)),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Alredy have a account? ",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: const Text(
                                "SignIN now",
                                style: TextStyle(
                                    color: Colors.black87,
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
