import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:primer_chat/helper/authenticate.dart';
import 'package:primer_chat/helper/constants.dart';
import 'package:primer_chat/helper/preferencesFunctions.dart';
import 'package:primer_chat/services/auth.dart';
import 'package:primer_chat/services/database.dart';
import 'package:primer_chat/views/conversationScreen.dart';
import 'package:primer_chat/views/language.dart';
import 'package:primer_chat/views/search.dart';
import 'package:primer_chat/widgets/widget_appbar.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethos authMethos = new AuthMethos();
  DatabaseMethos databaseMethos = DatabaseMethos();
  Stream chatRoomStream;
  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return ChatRoomTile(
                      snapshot.data.documents[index].data["chatroomId"]
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(Constants.myName, ""),
                      snapshot.data.documents[index].data["chatroomId"]);
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName =
        await PreferencesFunctions.getUserNameKeyInSharedPreference();
    databaseMethos.getChatRooms(Constants.myName).then((value) {
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
        backgroundColor: const Color(0xff294C60),
        //tittle
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LanguageScreen()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.translate),
            ),
          ),
          GestureDetector(
            onTap: () {
              authMethos.signOut();
              PreferencesFunctions.saveUserLoggedInSharedPreference(false);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff294C60),
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomTile(this.userName, this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationScreen(chatRoomId)));
      },
      child: Container(
        color: Colors.white24,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: const Color(0xff294C60),
                  borderRadius: BorderRadius.circular(40)),
              child: Text("${userName.substring(0, 1).toUpperCase()}",
                  style: mediumText()),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              userName,
              style: mediumTextBlack(),
            )
          ],
        ),
      ),
    );
  }
}
