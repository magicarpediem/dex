import 'package:dex/components/default_dropdown.dart';
import 'package:dex/components/list_card.dart';
import 'package:dex/data/filter.dart';
import 'package:dex/data/monster.dart';
import 'package:dex/data/region.dart';
import 'package:dex/data/type.dart';
import 'package:dex/screens/details_screen.dart';
import 'package:dex/util/constants.dart';
import 'package:dex/util/dex_loader.dart';
import 'package:dex/util/util.dart';
import 'package:flutter/material.dart';

class DexList extends StatefulWidget {
  @override
  _DexListState createState() => _DexListState();
}

// This is the homepage of the app.
// It will list out all of the mons in a SliverList using a FutureBuilder with the given filters
class _DexListState extends State<DexList> with Util, SingleTickerProviderStateMixin {
  // Used to clear the TextField when a user clicks cancel on the search bar
  TextEditingController textController;
  // ScrollController used to jump to top after a dropdown selection
  ScrollController scrollController;

  OverlayEntry overlayEntry;
  // Selected filters
  Filter filter = Filter();
  // DexLoader has an async call to load mons
  DexLoader dex = DexLoader();
  // Determines whether or not the user is using the search bar
  bool isSearchActive = false;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    textController = TextEditingController();
    /* focusNode.addListener(() {
      if (focusNode.hasFocus) {
        this.overlayEntry = this.createOverlayEntry();
        Overlay.of(context).insert(this.overlayEntry);
      } else {
        this.overlayEntry.remove();
      }
    });*/
  }

  @override
  void dispose() {
    scrollController.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter),
        onPressed: () {
          this.overlayEntry = createOverlayEntry();
          Overlay.of(context).insert(this.overlayEntry);
        },
      ),
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
        future: dex.loadDex(filter),
        builder: (context, snapshot) {
          // Create the sliver before putting it into CustomScrollView
          SliverList monstersSliver;
          if (snapshot.hasData) {
            List<Monster> monsters = snapshot.data;
            // Display 'No results found' if list is empty
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

  // Create the SliverAppBar. This will add the Region and Type dropdowns
  // SliverAppBar is used so the dropdowns can hide when scrolling
  SliverAppBar createSliverAppBar() => SliverAppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('Region:', style: textTheme(context).subhead),
            Dropdown(
              selection: filter.region,
              options: Region.values,
              onSelect: (newValue) => setState(() {
                // Animate to top after user makes selection
                animateTo(0.0);
                return filter.region = newValue;
              }),
            ),
            Text('Type:', style: textTheme(context).subhead),
            Dropdown(
              selection: filter.type,
              options: Type.values,
              onSelect: (newValue) => setState(() {
                // Animate to top after user makes selection
                animateTo(0.0);
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

  // Create SliverList. This will contain all the mons
  // It uses ListCard, which is just a custom Card component
  SliverList createSliverList(monsters) => SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index >= monsters.length) return null;
          Monster monster = monsters[index];
          return ListCard(
            monster: monster,
            context: context,
            onPress: () async {
              // Push to the poke info screen with a fade transition
              double destinationIndex = await Navigator.of(context).push(
                PageRouteBuilder(
                  // 0.8 second duration
                  transitionDuration: Duration(milliseconds: 800),
                  // page to go to
                  pageBuilder: (context, animation, secondaryAnimation) => DetailsScreen(
                    monster: monster,
                    dex: dex,
                  ),
                  // fade transition
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation.drive(
                        Tween(begin: 0.0, end: 1.0).chain(
                          CurveTween(curve: Curves.fastOutSlowIn),
                        ),
                      ),
                      child: child,
                    );
                  },
                ),
              );
              setState(() {
                // Animate to the right spot in the list if the pokemon is off screen
                if (isImageOffScreen(destinationIndex, context)) {
                  animateTo(calculateOffset(destinationIndex - 1));
                }
              });
            },
          );
        }),
      );

  // Sliver to use when there are no results
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
    textController.clear();
  }

  Widget searchBar() => Container(
        height: 40,
        child: TextField(
          controller: textController,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.bottom,
          style: textTheme(context).subhead,
          decoration: kInputTextDecoration,
          onChanged: (value) => setState(() {
            animateTo(0.0);
            filter.searchQuery = value;
          }),
          enabled: isSearchActive,
        ),
      );

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
            hideSearchBar();
          },
        ),
      );

  bool isImageOffScreen(index, context) {
    // Find position to go to
    double destinationOffset = calculateOffset(index - 1);
    // Find current position
    double currentOffset = Scrollable.of(context).position.pixels;
    // Find the index current list item from our position
    double currentIndex = calculateIndex(currentOffset);
    // Use the index to make a range of pokemon to estimate what's being shown on screen
    double minOffset = calculateOffset(currentIndex - 1);
    double maxOffset = calculateOffset(currentIndex + 4);

    // If the current position is not in the estimated current screen, move to position
    return destinationOffset > maxOffset || destinationOffset < minOffset ? true : false;
  }

  void animateTo(offset) => scrollController.animateTo(
        offset,
        duration: Duration(milliseconds: 1000),
        curve: Curves.ease,
      );

  OverlayEntry createOverlayEntry() {
    return OverlayEntry(
      builder: (context) {
        return Material(
          textStyle: TextStyle(
            color: Colors.black,
            fontFamily: 'Questrial',
            fontSize: 18,
          ),
          color: Color.fromARGB(100, 255, 255, 255),
          elevation: 4.0,
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Region:'),
                ButtonBar(
                  children: <Widget>[
                    RaisedButton(
                      child: Text('fire'),
                      onPressed: null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
