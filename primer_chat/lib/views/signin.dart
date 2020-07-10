import 'package:flutter/material.dart';
import 'package:primer_chat/widgets/widget_appbar.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
              TextField(
                //Texto en si
                decoration: textFieldHintDecoration("mail"),
                style: mediumTextBlack(),
              ),
              TextField(
                decoration: textFieldHintDecoration("contraseña"),
                style: mediumTextBlack(),
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
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.blueAccent, Colors.cyan]),
                    borderRadius: BorderRadius.circular(30)),
                child: Text("Inicia Sesion", style: mediumText()),
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
