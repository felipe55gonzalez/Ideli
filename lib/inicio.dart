import 'package:fatfast/pages/loginPage.dart';
import 'package:fatfast/pages/searchhbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';
import 'package:fatfast/model/places.dart';
import 'package:flutter/services.dart' show rootBundle;

UserData args;

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: new AppBar(
            title: new Text("Gordo de Acuña"),
            backgroundColor: Colors.amber,
            actions: <Widget>[
              // action button
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => Searchbar()));
                },
              ),
            ]),
        drawer: new Drawer(child: _drawerDivisions(context)),
        body: Container(
          child: FutureBuilder(
            future: loadplaces(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(children: <Widget>[
                  _carousel(snapshot.data)
                ],);
              } else if (snapshot.hasError) {
                return new Text("error");
              }
              return new CircularProgressIndicator();
            },
          ),
        ));
  }

  Widget _drawerDivisions(BuildContext context) {
    return new ListView(
      children: <Widget>[
        new UserAccountsDrawerHeader(
          accountName: new Text(args.nombre),
          accountEmail: new Text(args.correo),
          currentAccountPicture: new GestureDetector(
            onTap: () {
              print("i am the current user");
            },
            child: new CircleAvatar(
              backgroundImage: new NetworkImage(
                  "https://scontent.fntr6-1.fna.fbcdn.net/v/t1.0-9/49143061_2270089799670991_5546658948037214208_n.jpg?_nc_cat=111&_nc_oc=AQk5bVO0hn3jhqAStbrmUwP6ez5-4zVUZeynkQGwDaktCbpF3kHc29iWh4yMXiCaICj1lZtpvJhr1Bv-r5-tptXK&_nc_ht=scontent.fntr6-1.fna&oh=9aefed176a73d0b1bd13f9179fad45b4&oe=5E46281D"),
            ),
          ),
          decoration: new BoxDecoration(
              image: new DecorationImage(
                  fit: BoxFit.fill, image: AssetImage("assets/taco.jpg"))),
        ),
        new ListTile(
          title: new Text("Tacos"),
          trailing: new Image(
            image: NetworkImage(
                "https://www.stickpng.com/assets/images/58727fb4f3a71010b5e8ef08.png"),
            width: 40,
            height: 40,
          ),
          onTap: () {},
        ),
        new Divider(),
        new ListTile(
          title: new Text("Hamburgesas"),
          onTap: () {},
          trailing: new Image(
            image: NetworkImage(
                "https://i0.pngocean.com/files/623/62/539/hamburger-cheeseburger-buffalo-burger-breakfast-sandwich-fast-food-hamburger-menu.jpg"),
            width: 40,
            height: 40,
          ),
        ),
        new Divider(),
        new ListTile(
          title: new Text("Postres"),
          onTap: () {},
          trailing: new Icon(Icons.cancel),
        ),
        new Divider(),
        new ListTile(
          title: new Text("Pizza"),
          onTap: () {},
          trailing: new Icon(Icons.cancel),
        ),
        new Divider(),
        new ListTile(
          title: new Text("Cerrar sesion"),
          onTap: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacementNamed('/');
          },
          trailing: new Icon(Icons.cancel),
        )
      ],
    );
  }
}
Widget _carousel(PlacesList pls){

return CarouselSlider(
  height: 150.0,
  items: pls.place.map((i) {

    return Builder(
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 2.0),
          decoration: BoxDecoration(
            color: Colors.amber,
             image: new DecorationImage(
               image: new NetworkImage(i.urlimg),
               fit: BoxFit.fill
             ),
          ),
          child: 
          
           Text(i.name, style: TextStyle(fontSize: 16.0),
           ), 
        );
      },
    );
  }).toList(),
  enableInfiniteScroll: true,
   autoPlay: true,
   autoPlayInterval: Duration(seconds: 2),
   autoPlayAnimationDuration: Duration(milliseconds: 950),
   
);
}
Future<String> _loadplacesAsset() async {
  return await rootBundle.loadString('assets/places.json');
}

Future<PlacesList> loadplaces() async {
  String jsonString = await _loadplacesAsset();
  final jsonResponse = json.decode(jsonString);
  PlacesList lplaces = new PlacesList.fromJson(jsonResponse);
  return lplaces;
}
