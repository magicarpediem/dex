import 'package:dex/screens/dex_list.dart';
import 'package:flutter/material.dart';

import 'util/constants.dart';

void main() {
  runApp(Pokedex());
}

class Pokedex extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFFE3350D),
        canvasColor: kBackgroundColor,
        textTheme: TextTheme(
          headline: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontFamily: 'OdibeeSans',
            letterSpacing: 5,
          ),
          subhead: TextStyle(
            color: Colors.white,
            fontFamily: 'Questrial',
            fontSize: 18,
          ),
          subtitle: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade500,
            fontFamily: 'Questrial',
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
      title: kPokedexString,
      home: DexList(),
    );
  }
}
