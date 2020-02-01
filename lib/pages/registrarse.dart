import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

bool _isloading = false;

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController firstNameInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;
  TextEditingController phoneinputController;

  @override
  initState() {
    firstNameInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    confirmPwdInputController = new TextEditingController();
    phoneinputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Formato de Correo incorrecto';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 6) {
      return 'Minimo 6 Caracteres';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Registrarse"),
        ),
        body: cuerpo());
  }

  void signUp(FirebaseUser user) async {
    try {
      print("correo");
      await user.sendEmailVerification();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Verificacion"),
              content: Text("Se te ah enviado un correo de verificacion"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Regresar"),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                )
              ],
            );
          });
    } catch (e) {
      print("error");
      print(e.message);
    }
  }

  Widget _showCircularProgress() {
    return Center(child: CircularProgressIndicator());
  }

  Widget cuerpo() {
    if (_isloading) {
      return _showCircularProgress();
    } else {
      return Container(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
              child: Form(
            key: _registerFormKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Nombre*', hintText: "Tu Nombre y Apellido"),
                  controller: firstNameInputController,
                  validator: (value) {
                    if (value.length < 5) {
                      return "Nombre.";
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Correo*', hintText: "Ejemplo@gmail.com"),
                  controller: emailInputController,
                  keyboardType: TextInputType.emailAddress,
                  validator: emailValidator,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Celular*', hintText: "8777777"),
                  controller: phoneinputController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value.length < 10) {
                      return "Numero no valido";
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Contraseña*', hintText: "********"),
                  controller: pwdInputController,
                  obscureText: true,
                  validator: pwdValidator,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Confirma tu contraseña*',
                      hintText: "********"),
                  controller: confirmPwdInputController,
                  obscureText: true,
                  validator: pwdValidator,
                ),
                RaisedButton(
                  child: Text("Registrarse"),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      _isloading = true;
                    });
                    if (_registerFormKey.currentState.validate()) {
                      if (pwdInputController.text ==
                          confirmPwdInputController.text) {
                        FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: emailInputController.text,
                                password: pwdInputController.text)
                            .then((currentUser) => Firestore.instance
                                .collection("users")
                                .document(currentUser.user.uid)
                                .setData({
                                  "uid": currentUser.user.uid,
                                  "fname": firstNameInputController.text,
                                  "telefono": phoneinputController.text,
                                  "email": emailInputController.text,
                                })
                                .then((result) => {signUp(currentUser.user)})
                                .catchError((err) => print(err)))
                            .catchError((err) => print(err));
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Error"),
                                content: Text("Las contraseñas no coinciden"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Cerrar"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      }
                    }
                  },
                ),
                Text("¿Ya tienes Cuenta?"),
                FlatButton(
                  child: Text("!Inicia sesion Aqui¡"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          )));
    }
  }
}
