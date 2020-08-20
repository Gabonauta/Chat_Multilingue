import 'package:flutter/material.dart';
import 'package:primer_chat/helper/constants.dart';
import 'package:primer_chat/services/database.dart';
import 'package:primer_chat/widgets/widget_appbar.dart';
import 'package:translator/translator.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  //database
  DatabaseMethos databaseMethos = new DatabaseMethos();
  TextEditingController messageController = new TextEditingController();
  //Streaming
  Stream chatMessagesStream;

  Widget ChatMessageList() {
    return Container(
      padding: EdgeInsets.only(bottom: 80.0),
      child: StreamBuilder(
        stream: chatMessagesStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        snapshot.data.documents[index].data["message"],
                        snapshot.data.documents[index].data["sendby"] ==
                            Constants.myName);
                  })
              : Container();
        },
      ),
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendby": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      databaseMethos.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
    databaseMethos.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessagesStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        color: const Color(0xff001B2E),
        child: Stack(
          children: [
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  const Color(0xffADB6C4),
                  const Color(0xffADB6C4)
                ])),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            const Color(0xffADB6C4),
                            const Color(0xffADB6C4)
                          ]),
                          borderRadius: BorderRadius.circular(40)),
                      padding: EdgeInsets.all(7),
                      child: Image.asset(
                        "assets/images/translate.png",
                      ),
                    ),
                    Expanded(
                        child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                          hintText: "Escribe un mensaje",
                          border: InputBorder.none),
                      style: mediumTextBlack(),
                    )),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              const Color(0xffADB6C4),
                              const Color(0xffADB6C4)
                            ]),
                            borderRadius: BorderRadius.circular(40)),
                        padding: EdgeInsets.all(7),
                        child: Image.asset(
                          "assets/images/enviar.png",
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatefulWidget {
  @override
  _MessageTileState createState() => _MessageTileState();
  final message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);
}

class _MessageTileState extends State<MessageTile> {
  GoogleTranslator translator = GoogleTranslator();
  var mensaje;
  @override
  void initState() {
    super.initState();
    setState(() {
      mensaje = widget.message;
    });
  }

  Future<String> translation(String message) async {
    final newMessage = await translator.translate(message, to: 'en');
    return newMessage.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: widget.isSendByMe ? 0 : 24, right: widget.isSendByMe ? 24 : 0),
      margin: widget.isSendByMe
          ? EdgeInsets.only(right: 2, left: 50, top: 5, bottom: 5)
          : EdgeInsets.only(right: 50, left: 2, top: 5, bottom: 5),
      width: MediaQuery.of(context).size.width,
      alignment:
          widget.isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 14),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: widget.isSendByMe
                    ? [const Color(0xffFFEFD3), const Color(0xffFFEFD3)]
                    : [const Color(0xffFFC49B), const Color(0xffFFC49B)]),
            borderRadius: widget.isSendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23))),
        child: Row(children: [
          Expanded(
            child: Text(
              mensaje,
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
          ),
          GestureDetector(
            onTap: () async {
              var newmessage;
              try {
                newmessage = await translation(mensaje);
              } catch (e) {
                newmessage = "No se puede traducir";
              }

              setState(() {
                mensaje = newmessage;
              });
            },
            child: Container(
                child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    const Color(0xffADB6C4),
                    const Color(0xffADB6C4)
                  ]),
                  borderRadius: BorderRadius.circular(40)),
              padding: EdgeInsets.all(7),
              child: Image.asset(
                "assets/images/translate.png",
              ),
            )),
          )
        ]),
      ),
    );
  }
}
