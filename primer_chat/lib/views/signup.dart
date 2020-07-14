import 'package:flutter/material.dart';
import 'package:primer_chat/services/auth.dart';
import 'package:primer_chat/services/database.dart';
import 'package:primer_chat/views/chatRoom.dart';
import 'package:primer_chat/widgets/widget_appbar.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //clave del formulario
  final formKey = GlobalKey<FormState>();
  //controladores para textfield del formulario
  TextEditingController userTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  //controlar si el usuario esta logueado
  bool isLoading = false;
  //metodos de autenticacion
  AuthMethos authMethos = new AuthMethos();
  //metedos de base de datos
  DatabaseMethos databaseMethos = new DatabaseMethos();
  signMeUP() {
    if (formKey.currentState.validate()) {
      Map<String, String> userInfoMap = {
        "name": userTextEditingController.text,
        "email": emailTextEditingController.text
      };
      setState(() {
        isLoading = true;
      });
      authMethos
          .singUpwithEmailandPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
        //print("$val");
        databaseMethos.uploadUserInfo(userInfoMap);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height - 50,
                  //margen simetrico lado izquierdo y derecho de 24
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              //Texto en si
                              validator: (val) {
                                return val.isEmpty || val.length < 2
                                    ? "Ingresa tu nombre por favor"
                                    : null;
                              },
                              controller: userTextEditingController,
                              decoration: textFieldHintDecoration("apodo"),
                              style: mediumTextBlack(),
                            ),
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
                              //texto oculto
                              obscureText: true,
                              validator: (val) {
                                return val.length > 6
                                    ? null
                                    : "La contrasena debe ser mayor a 6 digitos";
                              },
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
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 10),
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
                          signMeUP();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Colors.blueAccent, Colors.cyan]),
                              borderRadius: BorderRadius.circular(30)),
                          child: Text("Registrate", style: mediumText()),
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
                        child:
                            Text("Registrate con Google", style: mediumText()),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Ya tienes una cuenta? ",
                                style: mediumTextBlack()),
                            GestureDetector(
                              onTap: () {
                                widget.toggle();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  "Inicia Sesion",
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
            ),
    );
  }
}
