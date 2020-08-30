import 'package:flutter/material.dart';
import 'package:primer_chat/helper/preferencesFunctions.dart';
import 'package:primer_chat/views/chatRoom.dart';
import 'package:primer_chat/widgets/widget_appbar.dart';

class LanguageScreen extends StatefulWidget {
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String dropdownValue = 'Español';
  final lang = PreferencesFunctions.getUserLanguageInSharedPreference();

  Widget languaje(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(fontSize: 20, color: Colors.black87),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['Español', 'Ingles', 'Frances', 'Portugues']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Text(
                "Elije un idioma",
                style: TextStyle(fontSize: 40, color: Colors.black87),
              ),
              SizedBox(
                height: 16,
              ),
              languaje(context),
              SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () {
                  PreferencesFunctions.saveUserLanguageInSharedPreference(
                      dropdownValue);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => ChatRoom()));
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        const Color(0xff294C60),
                        const Color(0xff294C60)
                      ]),
                      borderRadius: BorderRadius.circular(30)),
                  child: Text("Aceptar", style: mediumText()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
