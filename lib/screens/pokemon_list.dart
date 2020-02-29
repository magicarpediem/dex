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

// This is the homepage of the app.
// It will list out all of the mons in a SliverList using a FutureBuilder with the given filters
class _PokemonListState extends State<PokemonList> with Util {
  // ScrollController used to jump to top after a dropdown selection
  ScrollController controller;
  // Selected filters
  Filter filter = Filter();
  // DexLoader has an async call to load mons
  DexLoader dexLoader = DexLoader();
  // Determines whether or not the user is using the searchbar
  bool isSearchActive = false;

  @override
  void initState() {
    controller = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Build persistent appbar so sliverappbar can hide behind it
      appBar: buildAppBar(),
      body: FutureBuilder(
        // Load dex with properties set in filter
        future: dexLoader.loadDex(filter),
        builder: (context, snapshot) {
          // Create the sliver before putting it into CustomScrollView
          SliverList monstersSliver;
          if (snapshot.hasData) {
            List<Monster> monsters = snapshot.data;
            // Print 'No results found' if list is empty
            if (monsters.length <= 0) {
              monstersSliver = noResultsSliver;
            } else {
              // Otherwise create list from snapshot data
              monstersSliver = buildSliverList(monsters);
            }
          } else {
            // Show loading sign while waiting
            return Center(child: CircularProgressIndicator());
          }
          return CustomScrollView(
            controller: controller,
            physics: const BouncingScrollPhysics(),
            slivers: <Widget>[
              // Add SliverAppBar
              buildSliverAppBar(),
              // and SliverList of mons
              monstersSliver,
            ],
          );
        },
      ),
    );
  }

  // This will build the persistent appbar
  // AppBar includes a search IconButton
  AppBar buildAppBar() {
    // If the user clicked search, create searchfield in AppBar
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
            onChanged: (value) => setState(() => filter.searchQuery = value),
          ),
        ),
        elevation: 0,
        actions: <Widget>[
          clearIconButton(),
        ],
      );
    } else {
      // Otherwise, if the user clicked cancel, show title
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

  // Build the SliverAppBar. This will add the Region and Type dropdowns
  // SliverAppBar is used so the dropdowns can hide when scrolling
  SliverAppBar buildSliverAppBar() => SliverAppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('Region:', style: textTheme(context).subtitle1),
            Dropdown(
              selection: filter.region,
              options: Region.values,
              onSelect: (newValue) => setState(() {
                // Animate to top after user makes selection
                controller.animateTo(0, duration: Duration(milliseconds: 1000), curve: Curves.ease);
                return filter.region = newValue;
              }),
            ),
            Text('Type:', style: textTheme(context).subtitle1),
            Dropdown(
              selection: filter.type,
              options: Type.values,
              onSelect: (newValue) => setState(() {
                // Animate to top after user makes selection
                controller.animateTo(0, duration: Duration(milliseconds: 1000), curve: Curves.ease);
                return filter.type = newValue;
              }),
            ),
          ],
        ),
        // Snap will make the bar snap into place
        // It will be in or out, nothing in between
        snap: false,
        // Floating will make the bar accessible anywhere in the list
        floating: true,
        // Pinned will keep the bar pinned in place
        pinned: false,
      );

  SliverList buildSliverList(monsters) => SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index >= monsters.length) return null;
          Monster monster = monsters[index];
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
      );

  List<Widget> buildCardText(int id, String name, List types) {
    List<Widget> output = [];

    Widget nameAndNumber = Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 0, 4),
      child: Row(
        children: <Widget>[
          Text('$name'),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text('#$id', style: textTheme(context).subtitle2),
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
      padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
      child: Row(children: typeContainers),
    ));
    return output;
  }

  SliverList noResultsSliver = SliverList(
    delegate: SliverChildListDelegate(
      [
        Container(
          padding: EdgeInsets.all(40),
          alignment: Alignment.center,
          child: Text('No Results found'),
        ),
      ],
    ),
  );

  void showSearchBar() {
    isSearchActive = true;
  }

  void hideSearchBar() {
    isSearchActive = false;
    filter.searchQuery = '';
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
            filter.searchQuery = '';
          },
        ),
      );
}
