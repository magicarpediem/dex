import 'package:flutter/material.dart';

import 'data/monster.dart';
import 'routes/pokemon_info.dart';
import 'util/util.dart';
import 'data/dex_builder.dart';

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
      title: 'Pok\u00e9dex',
      home: Scaffold(
        backgroundColor: Colors.red.shade300,
        appBar: buildAppBar(),
        body: SafeArea(
          child: FutureBuilder(
            future: loadDex(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    if (index >= snapshot.data.length ?? 0) return null;
                    Monster monster = snapshot.data[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: buildText(monster.id, monster.nameMap['english'], monster.types),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PokemonInfo(monster: monster),
                                  ),
                                );
                              },
                              child: Image(
                                alignment: Alignment.centerRight,
                                image: AssetImage('assets/images/pokemon/small/${maskId(monster.id)}.png'),
                                height: 100,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }

  List<Widget> buildText(int id, String name, List types) {
    List<Widget> output = [];

    Widget topRow = Row(
      children: <Widget>[
        Text(
          '$name',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
          child: Text(
            '#$id',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
          ),
        ),
      ],
    );

    List<Widget> bottomRow = [];
    types.forEach(
      (type) => bottomRow.add(
        Container(
          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 3),
          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: getTypeColor(type),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$type',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      ),
    );

    output.add(topRow);
    output.add(Row(children: bottomRow));
    return output;
  }
}
