import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:perso/helper/authenticate.dart';
import 'package:perso/helper/constants.dart';
import 'package:perso/helper/helperfunction.dart';
import 'package:perso/services/auth.dart';
import 'package:perso/services/database.dart';
import 'package:perso/views/conversation.dart';
import 'package:perso/views/search.dart';
import 'package:perso/widgets/widgets.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream<QuerySnapshot>? chatRoomStream;

  AuthMethods authMethods = AuthMethods();

  Widget chatRoomList() {
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return ChatRoomsTile(
                        snapshot.data.documents[index].data["chatRoomId"]
                            .toString()
                            .replaceAll("_", "")
                            .replaceAll(Constants.myName, ""),
                        snapshot.data.documents[index].data["chatRoomId"]);
                  })
              : const Center(
                  child: Text(
                    "Search your friend name or email to start chatting",
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                );
        });
  }

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  getUserInfo() async {
    Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
    databaseMethods.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomStream = value;
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Icon(
          Icons.chat,
          color: Colors.greenAccent,
          size: 25.0,
        ),
        backgroundColor: Colors.cyan[900],
        actions: [
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Authenticate()));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan[900],
        child: const Icon(
          Icons.search,
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SearchScreen()));
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoom;
  // ignore: use_key_in_widget_constructors
  const ChatRoomsTile(this.userName, this.chatRoom);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationScreen(chatRoom)));
      },
      child: Container(
        color: Colors.black26,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(children: [
          Container(
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(40)),
            child: Text(userName.substring(0, 1).toUpperCase(),
                style: mediumTextField()),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            userName,
            style: mediumTextField(),
          )
        ]),
      ),
    );
  }
}
