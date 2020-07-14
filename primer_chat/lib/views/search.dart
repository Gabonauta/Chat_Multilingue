import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:primer_chat/services/database.dart';
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
  createChatRoomAndStarConversation(String username) {
    List<String> users = [
      username,
    ];
    // databaseMethos.createChatRoom(chatRoomId, chatRoomMap)
  }

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
              color: Colors.grey,
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
                          gradient: LinearGradient(
                              colors: [Colors.blueGrey, Colors.black]),
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

class SearchTile extends StatelessWidget {
  final String userName;
  final String userEmail;
  SearchTile({this.userName, this.userEmail});
  @override
  Widget build(BuildContext context) {
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
            onTap: () {},
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
}
