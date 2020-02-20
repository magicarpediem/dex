import 'package:dex/future/future_palette_generator.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

import 'data/monster.dart';
import 'util/util.dart';

class PokemonInfo extends StatefulWidget {
  final Monster monster;
  PokemonInfo({Key key, @required this.monster});
  @override
  _PokemonInfoState createState() => _PokemonInfoState(monster: monster);
}

class _PokemonInfoState extends State<PokemonInfo> with Util {
  _PokemonInfoState({Key key, @required this.monster});

  final Monster monster;
  Future<PaletteGenerator> palette;

  @override
  void initState() {
    super.initState();
    FuturePaletteGenerator future = FuturePaletteGenerator();
    palette = future.updatePaletteGenerator(monster.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(Util.appTitle),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: waitForBgColor(monster.id),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'No. ${monster.id}',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          monster.enName,
                          style: TextStyle(fontSize: 50),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget waitForBgColor(int id) {
    return FutureBuilder<PaletteGenerator>(
      future: palette,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null) {
            return Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Image.asset(
                getLargeImagePath(id),
              ),
            );
          } else {
            Color primaryColor = snapshot.data.dominantColor.color;
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                color: primaryColor,
                /*border: Border.all(
                  width: 8,
                  color: secondaryColor,
                ),*/
                //borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(getLargeImagePath(id)),
            );
          }
        } else {
          return Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Image.asset(
              getLargeImagePath(id),
            ),
          ); // loading
        }
      },
    );
  }
}
