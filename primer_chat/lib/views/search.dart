import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:primer_chat/helper/constants.dart';
import 'package:primer_chat/services/database.dart';
import 'package:primer_chat/views/conversationScreen.dart';
import 'package:primer_chat/widgets/widget_appbar.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  //controller del texto buscador
  TextEditingController searchTextEditingController =
      new TextEditingController();
  //instanciar buscador
  DatabaseMethos databaseMethos = new DatabaseMethos();

  //Funcion para buscar
  QuerySnapshot searchSnapShot;
  //lista de encontados
  Widget searchedlist() {
    return searchSnapShot != null
        ? ListView.builder(
            itemCount: searchSnapShot.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                userName: searchSnapShot.documents[index].data["name"],
                userEmail: searchSnapShot.documents[index].data["email"],
              );
            })
        : Container();
  }

  iniciateSearch() {
    databaseMethos
        .getUserByUsername(searchTextEditingController.text)
        .then((val) {
      setState(() {
        searchSnapShot = val;
      });
    });
  }

  //crear chatRoom, enviar al usuario a la vista de conversacion, pushreplacement
  createChatRoomAndStarConversation({String userName}) {
    print("${Constants.myName}");
    if (userName != Constants.myName) {
      String chatRoomId = getChatRoomId(userName, Constants.myName);
      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": chatRoomId
      };
      DatabaseMethos().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(chatRoomId)));
    } else {
      print("Debes enviar mensajes a otra persona");
    }
  }

  Widget SearchTile({String userName, String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: mediumTextBlack(),
              ),
              Text(
                userEmail,
                style: mediumTextBlack(),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStarConversation(userName: userName);
            },
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.blue, Colors.cyan]),
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text("Enviar mensaje"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: const Color(0xffADB6C4),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: searchTextEditingController,
                    decoration: InputDecoration(
                        hintText: "Busca un contacto",
                        border: InputBorder.none),
                    style: mediumTextBlack(),
                  )),
                  GestureDetector(
                    onTap: () {
                      iniciateSearch();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            const Color(0xff294C60),
                            const Color(0xff294C60)
                          ]),
                          borderRadius: BorderRadius.circular(40)),
                      padding: EdgeInsets.all(5),
                      child: Image.asset(
                        "assets/images/searchW.jpg",
                      ),
                    ),
                  )
                ],
              ),
            ),
            searchedlist()
          ],
        ),
      ),
    );
  }
}

//aplicando un id unico
getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
