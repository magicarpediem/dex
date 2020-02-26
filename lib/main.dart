import 'package:dex/pokemon_list.dart';
import 'package:dex/util/util.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Pokedex());
}

class Pokedex extends StatefulWidget {
  @override
  _PokedexState createState() => _PokedexState();
}

class _PokedexState extends State<Pokedex> with Util {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFFE3350D),
        canvasColor: backgroundColor,
        textTheme: TextTheme(
          title: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontFamily: 'OdibeeSans',
            letterSpacing: 5,
          ),
          subtitle: TextStyle(
            color: Colors.white,
            fontFamily: 'Questrial',
            fontSize: 18,
          ),
          body1: TextStyle(
            color: Colors.grey.shade800,
            fontFamily: 'Questrial',
            fontSize: 25,
          ),
          body2: TextStyle(
            color: Colors.grey.shade800,
            fontFamily: 'Questrial',
            fontSize: 18,
          ),
          caption: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade800,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      title: appTitleStr,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            appTitleStr,
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontFamily: 'OdibeeSans',
              letterSpacing: 5,
            ),
          ),
          elevation: 0,
        ),
        body: PokemonList(),
      ),
    );
  }
}
