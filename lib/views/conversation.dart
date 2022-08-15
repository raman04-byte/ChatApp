import 'package:flutter/material.dart';
import 'package:perso/helper/constants.dart';
import 'package:perso/services/database.dart';
import 'package:perso/widgets/widgets.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  const ConversationScreen(this.chatRoomId, {Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController messageController = TextEditingController();
  late Stream chatMessageStream;
  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data?.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return MessageTile(
                      snapshot.data.documents[index].data["message"],
                      snapshot.data.documents[index].data["sendBy"] == Constants.myName);
                })
            : Container();
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: const Color(0x54FFFFFF),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      style: simpleTextField(),
                      decoration: const InputDecoration(
                          hintText: "Message ...",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
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
                          "assets/images/send.png",
                          height: 25,
                          width: 25,
                        )),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  // ignore: use_key_in_widget_constructors
  const MessageTile(this.message, this.isSendByMe);
  @override
  Widget build(BuildContext context) {
   return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: isSendByMe ? 0 : 24,
          right: isSendByMe ? 24 : 0),
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: isSendByMe
            ? const EdgeInsets.only(left: 30)
            :const EdgeInsets.only(right: 30),
        padding: const EdgeInsets.only(
            top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: isSendByMe ?const BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            const BorderRadius.only(
        topLeft: Radius.circular(23),
          topRight: Radius.circular(23),
          bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: isSendByMe ? [
                const Color(0xff007EF4),
                const Color(0xff2A75BC)
              ]
                  : [
                const Color(0x1AFFFFFF),
                const Color(0x1AFFFFFF)
              ],
            )
        ),
        child: Text(message,
            textAlign: TextAlign.start,
            style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'OverpassRegular',
            fontWeight: FontWeight.w300)),
      ),
    );
  }
}

