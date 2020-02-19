import 'package:flutter/material.dart';
import '../data/monster.dart';
import '../util/util.dart';

class PokemonInfo extends StatelessWidget with Util {
  final Monster monster;

  PokemonInfo({Key key, @required this.monster});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.red.shade400,
        appBar: AppBar(
          titleSpacing: 0.0,
          backgroundColor: Colors.red,
          title: Center(
            child: Text(
              "Pok\u00e9dex",
              style: TextStyle(fontSize: 40, fontFamily: 'OdibeeSans'),
            ),
          ),
        ),
        body: SafeArea(
          child: Card(
            margin: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                Image.asset('assets/images/pokemon/large/${maskId(monster.id)}.png'),
                Text(
                  monster.enName,
                  style: TextStyle(fontSize: 50),
                )
              ],
            ),
          ),
        ));
  }
}
