import 'package:flutter/material.dart';
import 'package:primer_chat/helper/preferencesFunctions.dart';
import 'package:primer_chat/views/chatRoom.dart';
import 'helper/authenticate.dart';
import 'package:dcdg/dcdg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  bool userIsLoggedIn = false;
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    if (widget.userIsLoggedIn == null) {
      widget.userIsLoggedIn = false;
      getLoggedState();
      super.initState();
    }
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
