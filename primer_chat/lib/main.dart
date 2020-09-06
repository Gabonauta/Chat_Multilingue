import 'package:flutter/material.dart';
import 'package:primer_chat/helper/preferencesFunctions.dart';
import 'package:primer_chat/views/chatRoom.dart';
import 'helper/authenticate.dart';
import 'package:dcdg/dcdg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  var userIsLoggedIn;
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    getLoggedState();
    if (widget.userIsLoggedIn == null) {
      widget.userIsLoggedIn = false;
    }
    super.initState();
  }

  getLoggedState() async {
    await PreferencesFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        widget.userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: widget.userIsLoggedIn ? ChatRoom() : Authenticate(),
    );
  }
}
