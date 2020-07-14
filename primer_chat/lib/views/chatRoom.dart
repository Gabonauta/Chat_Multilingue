import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:primer_chat/helper/authenticate.dart';
import 'package:primer_chat/helper/constants.dart';
import 'package:primer_chat/helper/preferencesFunctions.dart';
import 'package:primer_chat/services/auth.dart';
import 'package:primer_chat/views/search.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethos authMethos = new AuthMethos();
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName =
        await PreferencesFunctions.getUserNameKeyInSharedPreference();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //tittle
        actions: [
          GestureDetector(
            onTap: () {
              authMethos.signOut();
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
    );
  }
}
