import 'package:dex/components/default_dropdown.dart';
import 'package:dex/data/filter.dart';
import 'package:dex/data/monster.dart';
import 'package:dex/data/region.dart';
import 'package:dex/data/type.dart';
import 'package:dex/screens/pokemon_info.dart';
import 'package:dex/util/constants.dart';
import 'package:dex/util/dex_loader.dart';
import 'package:dex/util/util.dart';
import 'package:flutter/material.dart';

class PokemonList extends StatefulWidget {
  @override
  _PokemonListState createState() => _PokemonListState();
}

// This is the homepage of the app.
// It will list out all of the mons in a SliverList using a FutureBuilder with the given filters
class _PokemonListState extends State<PokemonList> with Util, SingleTickerProviderStateMixin {
  // ScrollController used to jump to top after a dropdown selection
  ScrollController scrollController;
  // Selected filters
  Filter filter = Filter();
  // DexLoader has an async call to load mons
  DexLoader dexLoader = DexLoader();
  // Determines whether or not the user is using the searchbar
  bool isSearchActive = false;
  GlobalKey searchIconButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Build persistent appbar so SliverAppBar can hide behind it
      appBar: AppBar(
        centerTitle: true,
        title: AnimatedCrossFade(
          firstChild: Center(child: kAppTitle),
          secondChild: searchBar(),
          duration: Duration(milliseconds: 600),
          crossFadeState: isSearchActive ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        ),
        elevation: 0,
        actions: <Widget>[
          isSearchActive ? clearIconButton() : searchIconButton(),
        ],
      ),
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
              monstersSliver = createSliverList(monsters);
            }
          } else {
            // Show loading sign while waiting
            return Center(child: CircularProgressIndicator());
          }
          return CustomScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: <Widget>[
              // Add SliverAppBar
              createSliverAppBar(),
              // and SliverList of mons
              monstersSliver,
            ],
          );
        },
      ),
    );
  }

  // Build the SliverAppBar. This will add the Region and Type dropdowns
  // SliverAppBar is used so the dropdowns can hide when scrolling
  SliverAppBar createSliverAppBar() => SliverAppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('Region:', style: textTheme(context).subtitle1),
            Dropdown(
              selection: filter.region,
              options: Region.values,
              onSelect: (newValue) => setState(() {
                // Animate to top after user makes selection
                animateToTop();
                return filter.region = newValue;
              }),
            ),
            Text('Type:', style: textTheme(context).subtitle1),
            Dropdown(
              selection: filter.type,
              options: Type.values,
              onSelect: (newValue) => setState(() {
                // Animate to top after user makes selection
                animateToTop();
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

  SliverList createSliverList(monsters) => SliverList(
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
                    children: createCardText(monster.id, monster.name, monster.types),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).push(createRoute(monster));
                      setState(() => hideSearchBar());
                    },
                    child: Hero(
                      tag: monster.name,
                      child: Image(
                        alignment: Alignment.centerRight,
                        image: AssetImage(getLargeImagePath(monster.id)),
                        height: 100,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      );

  Route createRoute(monster) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 800),
      pageBuilder: (context, animation, secondaryAnimation) => PokemonInfo(monster: monster),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var fadeTween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.fastOutSlowIn));

        return FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        );
      },
    );
  }

  List<Widget> createCardText(int id, String name, List types) {
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

  void hideSearchBar() {
    isSearchActive = false;
    filter.searchQuery = '';
  }

  Widget searchBar() => Container(
        height: 40,
        child: TextField(
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.bottom,
          style: textTheme(context).subtitle1,
          decoration: kInputTextDecoration,
          onChanged: (value) => setState(() {
            animateToTop();
            return filter.searchQuery = value;
          }),
          enabled: isSearchActive,
        ),
      );

  IconButton searchIconButton() => IconButton(
        key: searchIconButtonKey,
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

  void animateToTop() => scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 1000),
        curve: Curves.ease,
      );
}
