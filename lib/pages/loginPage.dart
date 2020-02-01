import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fatfast/Firestore/Consultauid.dart';
import 'package:fatfast/Recursos/conexion.dart';
import 'package:fatfast/pages/registrarse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class ScreenArguments {
  String uid;
  String message;

  ScreenArguments(this.uid, this.message, String correo);
}

class UserData {
  String uid;
  String nombre;
  String correo;
  String telefono;

  UserData(this.uid, this.nombre, this.correo, this.telefono);
}

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;
String _nombre, _correo, _telefono;
bool _isLoading = false;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Iniciar Sesion"), centerTitle: true),
      body: cuerpo(context),
    );
  }

  Widget _showCircularProgress() {
    return Center(child: CircularProgressIndicator());
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Correo',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Contraseña',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
      ),
    );
  }

  Widget cuerpo(BuildContext context) {
    internet();
    if (_isLoading) {
      return Container(
          padding: EdgeInsets.all(16.0),
          child: new Form(
              child: new ListView(shrinkWrap: true, children: <Widget>[
            showlogo(),
            _showCircularProgress(),
          ])));
    } else {
      return Container(
          padding: EdgeInsets.all(16.0),
          child: new Form(
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                showlogo(),
                showEmailInput(),
                showPasswordInput(),
                SignInButton(
                  Buttons.Email,
                  text: "Iniciar con Correo",
                  onPressed: () {
                    
                  },
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: Divider()),
                    Text(
                      "Conectarse Con",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                Row(children: <Widget>[
                  Expanded(
                      child: SignInButton(
                    Buttons.Google,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    text: "Gmail",
                    onPressed: () {
                      _isLoading = true;
                      setState(() {});

                      googlelogin(context)
                          .then((FirebaseUser user) =>
                              {revisarUsuario(context, user)})
                          .catchError((e) => print(e));
                    },
                  )),
                  Expanded(
                      child: SignInButton(
                    Buttons.Facebook,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    onPressed: () {
                      _isLoading = true;
                      setState(() {});

                      _facebooklog(context)
                          .then((FirebaseUser user) =>
                              {revisarUsuario(context, user)})
                          .catchError((e) => print(e));
                    },
                    text: "Facebook",
                  ))
                ]),
                Row(
                  children: <Widget>[
                    Expanded(child: Divider()),
                    Text(
                      "O",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                SignInButton(
                  Buttons.Email,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => RegisterPage()));
                  },
                  text: "Registrarse con Correo",
                )
              ],
            ),
          ));
    }
  }

  Future<FirebaseUser> googlelogin(BuildContext context) async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    print(googleUser.toString());

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    print(googleAuth.toString());
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print(credential.toString());
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;

    return user;
  }

  Future<FirebaseUser> _facebooklog(BuildContext context) async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        print("logeado facebook");
        AuthCredential fbCredential = FacebookAuthProvider.getCredential(
            accessToken: result.accessToken.token);
        FirebaseUser user =
            (await _auth.signInWithCredential(fbCredential)).user;
        return user;
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("cancelado");
        break;
      case FacebookLoginStatus.error:
        print(result.errorMessage.toString());
        break;
    }
  }

  void revisarUsuario(BuildContext context, FirebaseUser user) {
    Consultas().consultaporUid(user.uid).then((DocumentSnapshot doc) {
      if (doc.exists) {
        print("hola de nuevo");
        _nombre = doc.data['fname'];
        _correo = doc.data['email'];
        _telefono = doc.data['telefono'];
      } else {
        print("Bienvedido");
        _nombre = user.displayName;
        _correo = user.email;
        _telefono = user.phoneNumber;

        Firestore.instance.collection("users").document(user.uid).setData({
          "uid": user.uid,
          "fname": user.displayName,
          "email": user.email,
          "telefono": user.phoneNumber
        }).then((result) => {});
      }
      _isLoading = false;
      Navigator.of(context).pushReplacementNamed('/Data',
          arguments: UserData(user.uid, _nombre, _correo, _telefono));
    });
  }

  Widget showlogo() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/logo2.png'),
        ),
      ),
    );
  }

  void internet() async {
    if (await checkConexion() == false) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("No se detecta Conexion"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Volver a interntar"),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                )
              ],
            );
          });
    }
  }
}
