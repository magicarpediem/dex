import 'package:dex/util/util.dart';
import 'package:flutter/material.dart';

import 'data/monster.dart';
import 'future/future_dex_builder.dart';
import 'pokemon_info.dart';

class PokemonList extends StatefulWidget {
  @override
  _PokemonListState createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> with Util {
  @override
  Widget build(BuildContext context) {
    FutureDexBuilder dex = FutureDexBuilder();
    return FutureBuilder(
      future: dex.loadDex(),
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
                        mainAxisSize: MainAxisSize.min,
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
                          image: AssetImage(getSmallImagePath(monster.id)),
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
    );
  }

  List<Widget> buildText(int id, String name, List types) {
    List<Widget> output = [];

    Widget topRow = Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 0, 4),
      child: Row(
        children: <Widget>[
          Text('$name'),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              '#$id',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
            ),
          ),
        ],
      ),
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
            type,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      ),
    );

    output.add(topRow);
    output.add(Padding(
      padding: const EdgeInsets.fromLTRB(5, 4, 0, 0),
      child: Row(children: bottomRow),
    ));
    return output;
  }
}
