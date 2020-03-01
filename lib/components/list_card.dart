import 'package:dex/data/monster.dart';
import 'package:dex/util/util.dart';
import 'package:flutter/material.dart';

// Used to create the cards used by the list screen
class ListCard extends StatelessWidget with Util {
  final Function onPress;
  final Monster monster;
  final BuildContext context;

  ListCard({this.onPress, this.monster, this.context});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        // Main row, contains text and image
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Column of name/number and types
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 4),
                  // Row of name and number
                  child: Row(
                    textBaseline: TextBaseline.alphabetic,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: <Widget>[
                      Text(
                        '${monster.name}',
                        style: textTheme(context).bodyText1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text('#${monster.id}', style: textTheme(context).subtitle2),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                  // Row of types
                  child: Row(
                    children: getTypePills(monster.types),
                  ),
                ),
              ],
            ),
            FlatButton(
              onPressed: onPress,
              // Hero widget to animate image growing and shrinking
              child: Hero(
                tag: monster.id,
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
  }
}
