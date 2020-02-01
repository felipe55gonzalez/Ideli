import 'package:flutter/material.dart';

import 'loginPage.dart';

UserData args;

class CheckDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text("Revisa Tus Datos"),
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Nombre*', hintText: "Tu Nombre y Apellido"),
                    controller: TextEditingController(text: args.nombre),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Correo*', hintText: "Ejemplo@gmail.com"),
                    controller: TextEditingController(text: args.correo),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Celular*', hintText: "877777777"),
                    controller: TextEditingController(text: args.telefono),
                    keyboardType: TextInputType.phone,
                  ),
                  RaisedButton(
                    child: Text("Guardar"),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/inicio',
                          arguments:
                              UserData(args.uid, args.nombre,args.correo,args.telefono));
                    },
                  ),
                ],
              ),
            ))));
  }
}
