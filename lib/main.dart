import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:perso/helper/helperfunction.dart';
import 'package:perso/views/chat_screen.dart';
import 'package:perso/views/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: const FirebaseOptions(
      apiKey: "AIzaSyB00yd14-veFvYpF1Uyc8H28EXfKswCfu4",
      appId: "1:253518728464:android:4d220a39d28e9bc7ca6995",
      messagingSenderId: "253518728464",
      projectId: "personal-3e7ae",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn = false;
  @override
  void initState() {
    getLoggedIn();
    super.initState();
  }

  getLoggedIn() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((val) {
      setState(() {
        userIsLoggedIn = val!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Chat room',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xff145C9E),
          scaffoldBackgroundColor: const Color(0xff1F1F1F),
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: userIsLoggedIn ? const ChatRoom() : const MySplash());
  }
}

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   // This widget is the root of your application.
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   late bool userIsLoggedIn;

//   @override
//   void initState() {
//     getLoggedInState();
//     super.initState();
//   }

//   getLoggedInState() async {
//     await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
//       setState(() {
//         userIsLoggedIn = value!;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'FlutterChat',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: const Color(0xff145C9E),
//         scaffoldBackgroundColor: Color(0xff1F1F1F),
//         accentColor: const Color(0xff007EF4),
//         fontFamily: "OverpassRegular",
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: userIsLoggedIn != null
//           ? userIsLoggedIn
//               ? const ChatRoom()
//               : Authenticate()
//           : Container(
//               child: Center(
//                 child: Authenticate(),
//               ),
//             ),
//     );
//   }
// }
