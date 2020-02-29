import 'package:dex/data/region.dart';
import 'package:dex/util/constants.dart';
import 'package:flutter/material.dart';

mixin Util {
  String getSmallImagePath(int i) => '$kSmallImagesPath${maskId(i)}.png';
  String getLargeImagePath(int i) => '$kLargeImagesPath${maskId(i)}.png';

  TextTheme textTheme(context) => Theme.of(context).textTheme;

  List<Color> getTypeColor(String type) => kTypeColorMap[type];

  int getStart(Region region) => kRegionNumberMap[region]['start'];
  int getEnd(Region region) => kRegionNumberMap[region]['end'];

  String maskId(int i) {
    if (i < 10) {
      return '00' + i.toString();
    } else if (i < 100) {
      return '0' + i.toString();
    } else {
      return i.toString();
    }
  }

  String stripEnum(enumerator) => enumerator.toString().split('.')[1];

  Icon transparentGreyQuote() => Icon(
        Icons.format_quote,
        size: 75,
        color: Color.fromARGB(40, 50, 50, 50),
      );

  Divider defaultDivider() => Divider(
        thickness: 2,
        indent: 40,
        endIndent: 40,
        height: 5,
      );

  bool isAlpha(String str) => str.contains(new RegExp(r'[A-Za-z]'));
  bool isNumeric(String str) => str.contains(new RegExp(r'[0-9]'));
}
