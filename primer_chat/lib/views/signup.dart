import 'package:flutter/material.dart';
import 'package:primer_chat/widgets/widget_appbar.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp>{
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                decoration: textFieldHintDecoration("apodo"),
                style: mediumTextBlack(),
             ),
             TextField(
               //Texto en si
                decoration: textFieldHintDecoration("mail"),
                style: mediumTextBlack(),
             ),
             TextField(
               decoration: textFieldHintDecoration("contraseña"),
               style: mediumTextBlack(),
             ),
             SizedBox(height: 8,),
             Container(
               alignment: Alignment.centerRight,
               child: Container(
                 padding: EdgeInsets.symmetric(vertical:8, horizontal:10),
                 child: Text("Olvidaste tu contraseña?", style: TextStyle(fontSize: 18),),
             ),
             ),
             SizedBox(height: 16,),
             Container(
               alignment: Alignment.center,
               width: MediaQuery.of(context).size.width,
               padding: EdgeInsets.symmetric(vertical:20),
               decoration: BoxDecoration(
                 gradient: LinearGradient(colors: 
                 [Colors.blueAccent, Colors.cyan]
                 ),
               borderRadius: BorderRadius.circular(30)
               ),
               child: Text("Registrate", style: mediumText()),
             ),
             SizedBox(height: 16,),
             Container(
               alignment: Alignment.center,
               width: MediaQuery.of(context).size.width,
               padding: EdgeInsets.symmetric(vertical:20),
               decoration: BoxDecoration(
                 gradient: LinearGradient(colors: 
                 [Colors.blueAccent, Colors.redAccent, Colors.yellowAccent]
                 ),
               borderRadius: BorderRadius.circular(30)
               ),
               child: Text("Registrate con Google", style: mediumText()),
             ),  
             SizedBox(height: 16,),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children:[
                 Text("Ya tienes una cuenta? ", style: mediumTextBlack()),
                 Text("Inicia Sesion", style: TextStyle(color: Colors.black87, fontSize:18, decoration: TextDecoration.underline), )
               ]
             ),
             SizedBox(height: 50,),
           ], 
        ),
      ),
      ),
    );
  }
}