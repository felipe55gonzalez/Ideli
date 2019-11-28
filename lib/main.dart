import 'package:fatfast/inicio.dart';
import 'package:fatfast/pages/checkdata.dart';
import 'package:flutter/material.dart';
import 'package:fatfast/pages/loginPage.dart';
import 'package:floating_search_bar/floating_search_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Iniar Sesion',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.amber,
        ),
        home:   new Login() , 
        routes: <String,WidgetBuilder>{
          '/inicio':(BuildContext context) => new Inicio(),
           '/Data':(BuildContext context) => new CheckDataPage()
        }        
        );
  }
}
