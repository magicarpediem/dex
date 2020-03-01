import 'package:dex/data/monster.dart';
import 'package:dex/util/constants.dart';
import 'package:dex/util/dex_loader.dart';
import 'package:dex/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PokemonInfo extends StatefulWidget {
  final Monster monster;
  final DexLoader dex;

  PokemonInfo({Key key, @required this.monster, this.dex});

  @override
  _PokemonInfoState createState() => _PokemonInfoState(monster: monster, dex: dex);
}

class _PokemonInfoState extends State<PokemonInfo> with Util {
  Monster monster;
  final DexLoader dex;
  List<Monster> monsters;
  PageController pageController;

  _PokemonInfoState({this.monster, this.dex});

  @override
  void initState() {
    super.initState();
    monsters = dex.currentDex;
    pageController = PageController(initialPage: monsters.indexOf(monster));
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        controller: pageController,
        itemCount: monsters.length,
        itemBuilder: (context, index) {
          monster = monsters[index];
          return createInfo(index);
        },
      ),
    );
  }

  Widget createInfo(index) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(monster.hexColor), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.center,
        ),
        color: Color(monster.hexColor),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: getTypePills(monster.types),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context, index.toDouble()),
                      iconSize: 30,
                    ),
                  ),
                  Center(
                    child: Hero(
                      tag: monster.id,
                      child: Image.asset(
                        getLargeImagePath(monster.id),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'No. ${monster.id}',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        monster.name,
                        style: TextStyle(fontSize: 50),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        kDefaultDivider(Colors.grey.shade400),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 20,
                          ),
                          child: Text(
                            monster.description,
                            style: textTheme(context).caption,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        kDefaultDivider(Colors.grey.shade400),
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
