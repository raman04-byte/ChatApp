import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:perso/helper/constants.dart';
import 'package:perso/views/conversation.dart';
import 'package:perso/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:perso/services/database.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchEditingController = TextEditingController();
  QuerySnapshot<Map<String, dynamic>>? searchSnapshot;

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot?.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return searchTile(
                userName: searchSnapshot?.docs[index].data()["name"],
                userEmail: searchSnapshot?.docs[index].data()["email"],
              );
            })
        : Container();
  }

  initiateSearch() {
    databaseMethods.getUsername(searchEditingController.text).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  createChatRoomAndStartConversation({required String userName}) {
    if (userName != Constants.myName) {
      String chatRoomId = getChatRoomId(userName, Constants.myName);
      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomID": chatRoomId
      };
      databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(chatRoomId)));
    } else {
      if (kDebugMode) {
        print("You can't send message to yourself");
      }
    }
  }

  Widget searchTile({String? userName, String? userEmail}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName!,
                style: mediumTextField(),
              ),
              Text(
                userEmail!,
                style: mediumTextField(),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(userName: userName);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                "Message",
                style: mediumTextField(),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  bool isLoading = false;
  bool haveUserSearched = false;

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
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  color: const Color(0x54FFFFFF),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchEditingController,
                          style: simpleTextField(),
                          decoration: const InputDecoration(
                              hintText: "Search Username or Email ",
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          initiateSearch();
                        },
                        child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                    colors: [
                                      Color(0x36FFFFFF),
                                      Color(0x0FFFFFFF)
                                    ],
                                    begin: FractionalOffset.topLeft,
                                    end: FractionalOffset.bottomRight),
                                borderRadius: BorderRadius.circular(40)),
                            padding: const EdgeInsets.all(12),
                            child: Image.asset(
                              "assets/images/search_white.png",
                              height: 25,
                              width: 25,
                            )),
                      )
                    ],
                  ),
                ),
                searchList()
              ],
            ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    // ignore: unnecessary_string_escapes
    return "$b\_$a";
  } else {
    // ignore: unnecessary_string_escapes
    return "$a\_$b";
  }
}
