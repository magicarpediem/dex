import 'package:flutter/material.dart';

import 'data/monster.dart';
import 'util/util.dart';

class PokemonInfo extends StatefulWidget {
  final Monster monster;

  PokemonInfo({Key key, @required this.monster});

  @override
  _PokemonInfoState createState() => _PokemonInfoState(monster: monster);
}

class _PokemonInfoState extends State<PokemonInfo> with Util {
  final Monster monster;
  _PokemonInfoState({Key key, @required this.monster});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          appTitleStr,
          style: textTheme(context).title,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(monster.hexColor), Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  color: Color(monster.hexColor),
                ),
                child: Image.asset(getLargeImagePath(monster.id)),
              ),
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
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          monster.name,
                          style: TextStyle(fontSize: 50),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        defaultDivider(),
                        Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                transparentGreyQuote(),
                                transparentGreyQuote(),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 20,
                              ),
                              child: Text(
                                monster.description,
                                style: textTheme(context).caption,
                              ),
                            ),
                          ],
                        ),
                        defaultDivider(),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
