import 'package:dex/screens/main_screen.dart';
import 'package:dex/util/dex_loader.dart';
import 'package:dex/util/dex_provider.dart';
import 'package:flutter/material.dart';

import 'util/constants.dart';

void main() {
  runApp(Pokedex());
}

class Pokedex extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DexProvider(
      dex: DexLoader(),
      child: MaterialApp(
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
              color: Colors.black,
              fontFamily: 'Questrial',
              fontSize: 25,
            ),
            body2: TextStyle(
              color: Colors.black,
              fontFamily: 'Questrial',
              fontSize: 18,
            ),
            caption: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        title: kPokedexString,
        home: MainScreen(),
      ),
    );
  }
}
