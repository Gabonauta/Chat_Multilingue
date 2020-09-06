import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    backgroundColor: const Color(0xff294C60),
    title: Image.asset("assets/images/tittle.png"),
  );
}

InputDecoration textFieldHintDecoration(String textHint) {
  return InputDecoration(
      hintText: textHint,
      hintStyle: TextStyle(color: Colors.black38),
      //Linea abajo del texto cuando estas en ella
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
      //Linea abajo del texto cuando no estas en ella
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.black87)));
}

TextStyle mediumText() {
  return TextStyle(fontSize: 18, color: Colors.white70);
}

TextStyle mediumTextBlack() {
  return TextStyle(fontSize: 18, color: Colors.black87);
}
