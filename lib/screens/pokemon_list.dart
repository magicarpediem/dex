import 'package:dex/components/default_dropdown.dart';
import 'package:dex/data/filter.dart';
import 'package:dex/data/monster.dart';
import 'package:dex/data/region.dart';
import 'package:dex/data/type.dart';
import 'package:dex/screens/pokemon_info.dart';
import 'package:dex/util/dex_loader.dart';
import 'package:dex/util/util.dart';
import 'package:flutter/material.dart';
import 'package:dex/util/constants.dart';

class PokemonList extends StatefulWidget {
  @override
  _PokemonListState createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> with Util {
  Filter filter = Filter();
  DexLoader dexLoader = DexLoader();
  bool isSearchActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: FutureBuilder(
        future: dexLoader.loadDex(filter),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverAppBar(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text('Region:', style: textTheme(context).subtitle1),
                      Dropdown(
                        selection: filter.region,
                        options: Region.values,
                        onSelect: (newValue) => setState(() => filter.region = newValue),
                      ),
                      Text('Type:', style: textTheme(context).subtitle1),
                      Dropdown(
                        selection: filter.type,
                        options: Type.values,
                        onSelect: (newValue) => setState(() => filter.type = newValue),
                      ),
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
                              children: buildCardText(monster.id, monster.name, monster.types),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PokemonInfo(monster: monster)),
                                );
                                setState(() => hideSearchBar());
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
        },
      ),
    );
  }

  List<Widget> buildCardText(int id, String name, List types) {
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
          child: Text(type, style: textTheme(context).bodyText2),
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

  Widget buildAppBar() {
    if (isSearchActive) {
      return AppBar(
        centerTitle: true,
        title: Container(
          height: 40,
          child: TextField(
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.bottom,
            style: textTheme(context).subtitle1,
            decoration: kInputTextDecoration,
            onChanged: (value) => setState(() => filter.name = value),
          ),
        ),
        elevation: 0,
        actions: <Widget>[
          clearIconButton(),
        ],
      );
    } else {
      return AppBar(
        centerTitle: true,
        title: kAppTitle,
        elevation: 0,
        actions: <Widget>[
          searchIconButton(),
        ],
      );
    }
  }

  void showSearchBar() {
    isSearchActive = true;
  }

  void hideSearchBar() {
    isSearchActive = false;
    filter.name = '';
  }

  IconButton searchIconButton() => IconButton(
        icon: Icon(Icons.search),
        onPressed: () => setState(
          () => isSearchActive = true,
        ),
      );

  IconButton clearIconButton() => IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => setState(
          () {
            isSearchActive = false;
            filter.name = '';
          },
        ),
      );
}
