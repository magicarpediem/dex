import 'package:dex/components/filter_dialog.dart';
import 'package:dex/components/list_card.dart';
import 'package:dex/data/filter_keys.dart';
import 'package:dex/data/monster.dart';
import 'package:dex/data/region.dart';
import 'package:dex/screens/details_screen.dart';
import 'package:dex/util/constants.dart';
import 'package:dex/util/dex_provider.dart';
import 'package:dex/util/util.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

// This is the homepage of the app.
// It will list out all of the mons in a SliverList using a FutureBuilder with the given filters
class _MainScreenState extends State<MainScreen> with Util, SingleTickerProviderStateMixin {
  // Used to clear the TextField when a user clicks cancel on the search bar
  TextEditingController textController;

  // ScrollController used to jump to top after a dropdown selection
  ScrollController scrollController;
  OverlayEntry overlayEntry;

  // Determines whether or not the user is using the search bar
  bool isSearchActive = false;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('************ BUILD MAIN SCREEN ***************');
    DexProvider dex = DexProvider.of(context);
    FilterKeys filter = DexProvider.of(context).filter ?? FilterKeys(regions: [Region.Alola]);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.filter_list),
          onPressed: () {
            setState(() {
              showDialog(
                context: context,
                builder: (context) {
                  return FilterDialog();
                },
                barrierDismissible: false,
              ).then((x) {
                if (x != null) {
                  animateTo(0.0);
                  setState(() {
                    DexProvider.of(context).load();
                  });
                }
              });
            });
          }),
      // Build persistent appbar so SliverAppBar can hide behind it
      appBar: AppBar(
        centerTitle: true,
        title: AnimatedCrossFade(
          firstChild: Center(child: kAppTitle),
          secondChild: searchBar(filter),
          duration: Duration(milliseconds: 600),
          crossFadeState: isSearchActive ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        ),
        elevation: 0,
        actions: <Widget>[
          isSearchActive ? clearIconButton(filter) : searchIconButton(),
        ],
      ),
      body: FutureBuilder(
        // Load dex with properties set in filter
        future: dex.load(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // Show loading sign while waiting
            return Center(child: CircularProgressIndicator());
          } else {
            List<Monster> monsters = snapshot.data;
            return CustomScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: <Widget>[
                // Create SliverList of mons
                // Display 'No results found' if list is empty : otherwise create list from snapshot data
                monsters.length <= 0 ? noResultsSliver : createSliverList(monsters),
              ],
            );
          }
        },
      ),
    );
  }

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

  void hideSearchBar(filter) {
    isSearchActive = false;
    filter.searchQuery = '';
    textController.clear();
  }

  Widget searchBar(filter) => Container(
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

  IconButton clearIconButton(filter) => IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => setState(
          () {
            hideSearchBar(filter);
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
}
