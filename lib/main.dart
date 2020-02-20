import 'package:dex/pokemon_list.dart';
import 'package:dex/util/util.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Pokedex());
}

class Pokedex extends StatelessWidget with Util {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFFE3350D),
        scaffoldBackgroundColor: Colors.red.shade300,
        textTheme: TextTheme(
          body1: TextStyle(
            color: Colors.grey.shade800,
            fontFamily: 'Questrial',
            fontSize: 25,
          ),
        ),
        appBarTheme: AppBarTheme(
          textTheme: TextTheme(
            title: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontFamily: 'OdibeeSans',
              letterSpacing: 5,
            ),
          ),
        ),
      ),
      title: Util.appTitle,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(Util.appTitle),
        ),
        body: SafeArea(
          child: PokemonList(),
        ),
      ),
    );
  }
}
