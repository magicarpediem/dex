import 'dart:async';

import 'package:dex/util/region.dart';
import 'package:dex/util/type.dart';
import 'package:dex/util/util.dart';
import 'package:flutter/material.dart';
import 'data/monster.dart';
import 'pokemon_info.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class PokemonList extends StatefulWidget {
  @override
  _PokemonListState createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> with Util {
  Region selectedRegion = Region.All;
  Type selectedType = Type.All;

  StreamController streamController;

  Future<List<Monster>> loadDex(region) async {
    List<Monster> output = [];
    String jsonStr = await rootBundle.loadString(dexJsonPath);
    List jsonList = json.decode(jsonStr);
    jsonList.forEach((element) => output.add(Monster.fromJson(element)));
    if (selectedRegion != Region.All) {
      output = output
          .where(
            (entry) => entry.id > getStart(selectedRegion) && entry.id <= getEnd(selectedRegion),
          )
          .toList();
    }
    if (selectedType != Type.All) {
      output = output
          .where(
            (entry) => entry.types.contains(stripEnum(selectedType)),
          )
          .toList();
    }
    return output;
  }

  @override
  void initState() {
    streamController = new StreamController();
    super.initState();
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: Region.All,
      stream: streamController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return FutureBuilder(
              future: loadDex(selectedRegion),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: <Widget>[
                      SliverAppBar(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text('Region:', style: textTheme(context).subtitle),
                            Dropdown(parent: this, selection: selectedRegion, options: Region.values),
                            Text('Type:', style: textTheme(context).subtitle),
                            Dropdown(parent: this, selection: selectedType, options: Type.values),
                          ],
                        ),
                        snap: false,
                        floating: true,
                        pinned: false,
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          if (index >= snapshot.data.length) return null;
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
                                    children: buildText(monster.id, monster.name, monster.types),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => PokemonInfo(monster: monster)),
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
                        }),
                      ),
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              });
        } else {
          return Center(child: Text('StreamBuilder is broken'));
        }
      },
    );
  }

  List<Widget> buildText(int id, String name, List types) {
    List<Widget> output = [];

    Widget nameAndNumber = Padding(
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

    List<Widget> typeContainers = [];
    types.forEach(
      (type) => typeContainers.add(
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
          child: Text(type, style: textTheme(context).body2),
        ),
      ),
    );

    output.add(nameAndNumber);
    output.add(Padding(
      padding: const EdgeInsets.fromLTRB(5, 4, 0, 0),
      child: Row(children: typeContainers),
    ));
    return output;
  }

  updateSelection(selection) => setState(() {
        selection is Region ? selectedRegion = selection : selectedType = selection;
      });
}

class Dropdown extends StatelessWidget with Util {
  _PokemonListState parent;
  final dynamic selection;
  final List options;

  Dropdown({this.parent, this.selection, this.options});
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        value: selection,
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.white,
        ),
        iconSize: 20,
        elevation: 16,
        style: textTheme(context).subtitle,
        isDense: true,
        onChanged: (newValue) => this.parent.updateSelection(newValue),
        items: options.map<DropdownMenuItem>((value) {
          return DropdownMenuItem(value: value, child: Text(stripEnum(value)));
        }).toList(),
      ),
    );
  }
}
