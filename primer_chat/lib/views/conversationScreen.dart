import 'package:flutter/material.dart';
import 'package:primer_chat/helper/constants.dart';
import 'package:primer_chat/helper/preferencesFunctions.dart';
import 'package:primer_chat/services/database.dart';
import 'package:primer_chat/widgets/widget_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  final String person;
  ConversationScreen(this.chatRoomId, this.person);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  String dropdownValue = 'Español';
  final lang = PreferencesFunctions.getUserLanguageInSharedPreference();

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
      appBar: AppBar(
          backgroundColor: const Color(0xff294C60),
          title:
              /*Title(
            color: const Color(0xff294C60),
            child: 
          ),*/
              new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                Text(widget.person),
                Container(
                    color: const Color(0xffADB6C4),
                    child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                            alignedDropdown: true,
                            child: new DropdownButton<String>(
                              value: dropdownValue,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(
                                  fontSize: 20, color: Colors.black87),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                  PreferencesFunctions
                                      .saveUserLanguageInSharedPreference(
                                          dropdownValue);
                                });
                              },
                              items: <String>[
                                'Español',
                                'Ingles',
                                'Frances',
                                'Portugues'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ))))
              ])),
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
  bool isTranslated = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      mensaje = widget.message;
    });
  }

  Future<String> translation(String message) async {
    final lang = PreferencesFunctions.getUserLanguageInSharedPreference();
    String asing = "";
    if (this.isTranslated == false) {
      isTranslated = true;
      if (await lang == "Ingles") {
        asing = 'en';
      } else if (await lang == "Frances") {
        asing = 'fr';
      } else if (await lang == "Español") {
        asing = 'es';
      } else if (await lang == "Portugues") {
        asing = 'pt';
      }
    } else {
      asing = 'es';
      isTranslated = false;
    }

    final newMessage = await translator.translate(message, to: asing);
    return newMessage.toString();
  }

  Future<String> translation2(String message) async {
    final lang = PreferencesFunctions.getUserLanguageInSharedPreference();
    String asing = "";

    asing = 'es';
    isTranslated = false;

    final newMessage = await translator.translate(message, to: asing);
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
              var newmessage = widget.message;
              try {
                newmessage = await translation(mensaje);
              } catch (e) {
                print(e.toString());

                newmessage = "No se puede traducir";
              }

              setState(() {
                mensaje = newmessage;
              });
            },
            onDoubleTap: () async {
              var newmessage = widget.message;
              try {
                newmessage = await translation2(mensaje);
              } catch (e) {
                print(e.toString());

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
