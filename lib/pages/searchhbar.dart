import 'package:flutter/material.dart';

import 'package:floating_search_bar/floating_search_bar.dart';

String word;

class Searchbar extends StatefulWidget {
  @override
  _SearchbarState createState() => _SearchbarState();
}

class _SearchbarState extends State<Searchbar> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Iniar Sesion',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: FloatingSearchBar.builder(
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Text(index.toString()),
          );
        },
        trailing: FloatingActionButton(
          foregroundColor: Colors.black,
          backgroundColor: Colors.yellow[600],
          elevation: 50,
          child: Icon(Icons.search),
          onPressed: () {
            print(word);
          },
        ),
        onChanged: (String value) {
          word = value;
        },
        onTap: () {},
        decoration: InputDecoration.collapsed(
          hintText: "Buscar...",
        ),
      ),
    );
  }
}
