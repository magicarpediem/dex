import 'package:flutter/material.dart';

mixin Util {
  final Map<String, Color> _typeColorMap = {
    'Fire': Colors.red.shade200,
    'Water': Colors.blue.shade200,
    'Grass': Colors.green.shade200,
    'Electric': Colors.yellow.shade400,
    'Psychic': Colors.pink.shade300,
    'Ice': Colors.cyanAccent.shade200,
    'Dragon': Colors.deepPurple,
    'Dark': Colors.grey.shade800,
    'Fairy': Colors.pink.shade200,
    'Normal': Colors.grey.shade300,
    'Fighting': Colors.orange.shade800,
    'Flying': Colors.blue.shade100,
    'Poison': Colors.purple.shade200,
    'Ground': Colors.yellow.shade800,
    'Rock': Colors.brown.shade300,
    'Bug': Colors.lightGreen.shade300,
    'Ghost': Colors.deepPurple.shade400,
    'Steel': Colors.blueGrey.shade300,
  };

  AppBar buildAppBar() => AppBar(
        titleSpacing: 0.0,
        backgroundColor: Colors.red,
        title: Center(
          child: Text(
            "Pok\u00e9dex",
            style: TextStyle(fontSize: 40, fontFamily: 'OdibeeSans'),
          ),
        ),
      );

  Color getTypeColor(String type) => _typeColorMap[type];

  String maskId(int i) {
    if (i < 10) {
      return '00' + i.toString();
    } else if (i < 100) {
      return '0' + i.toString();
    } else {
      return i.toString();
    }
  }
}
