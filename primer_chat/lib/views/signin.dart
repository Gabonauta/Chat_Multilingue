import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:primer_chat/helper/preferencesFunctions.dart';
import 'package:primer_chat/services/auth.dart';
import 'package:primer_chat/services/database.dart';
import 'package:primer_chat/views/chatRoom.dart';
import 'package:primer_chat/widgets/widget_appbar.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  //authmethos
  AuthMethos authMethos = new AuthMethos();
  //Database
  DatabaseMethos databaseMethos = new DatabaseMethos();
  //controladores para textfield del formulario
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool isLoading = false;
  QuerySnapshot snapshotUSerInfo;
  signIn() {
    if (formkey.currentState.validate()) {
      PreferencesFunctions.saveUserEmailKeyInSharedPreference(
          emailTextEditingController.text);
      databaseMethos
          .getUserByUserEmail(emailTextEditingController.text)
          .then((val) {
        snapshotUSerInfo = val;
        PreferencesFunctions.saveUserNameKeyInSharedPreference(
            snapshotUSerInfo.documents[0].data['name']);
      });
      //
      setState(() {
        isLoading = true;
      });
      authMethos
          .signInWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((value) {
        if (value != null) {
          PreferencesFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //aqui va la estructura de la pantalla de inicio que es login
      appBar: appBarMain(context),
      body: Container(
        alignment: Alignment.bottomCenter,
        child: Container(
          //margen simetrico lado izquierdo y derecho de 24
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: formkey,
                child: Column(
                  children: [
                    TextFormField(
                      //Texto en si
                      validator: (val) {
                        return RegExp(
                                    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                .hasMatch(val)
                            ? null
                            : "Utilice un email valido";
                      },
                      controller: emailTextEditingController,
                      decoration: textFieldHintDecoration("mail"),
                      style: mediumTextBlack(),
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: passwordTextEditingController,
                      decoration: textFieldHintDecoration("contraseña"),
                      style: mediumTextBlack(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Text(
                    "Olvidaste tu contraseña?",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () {
                  signIn();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.blueAccent, Colors.cyan]),
                      borderRadius: BorderRadius.circular(30)),
                  child: Text("Inicia Sesion", style: mediumText()),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.blueAccent,
                      Colors.redAccent,
                      Colors.yellowAccent
                    ]),
                    borderRadius: BorderRadius.circular(30)),
                child: Text("Inicia Sesion con Google", style: mediumText()),
              ),
              SizedBox(
                height: 16,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("No tienes una cuenta? ", style: mediumTextBlack()),
                GestureDetector(
                  onTap: () {
                    widget.toggle();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "Registrate",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                )
              ]),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
