import 'package:dex/util/region.dart';
import 'package:flutter/material.dart';

mixin Util {
  final String appTitleStr = 'Pok\u00e9dex';

  final int totalPokemon = 809;

  TextTheme textTheme(context) => Theme.of(context).textTheme;

  final String dexJsonPath = 'assets/data/dex_4.json';
  final String smallImagesPath = 'assets/images/pokemon/small/';
  final String largeImagesPath = 'assets/images/pokemon/large/';
  String getSmallImagePath(int i) => '$smallImagesPath${maskId(i)}.png';
  String getLargeImagePath(int i) => '$largeImagesPath${maskId(i)}.png';

  final Color backgroundColor = Colors.red.shade400;

  final Map<String, List<Color>> _typeColorMap = {
    'Fire': [Color(0xfffd7d24), Color(0xfffd7d24)],
    'Water': [Color(0xff4592c4), Color(0xff4592c4)],
    'Grass': [Color(0xff9bcc50), Color(0xff9bcc50)],
    'Electric': [Color(0xffeed535), Color(0xffeed535)],
    'Psychic': [Color(0xfff366b9), Color(0xfff366b9)],
    'Ice': [Color(0xff51c4e7), Color(0xff51c4e7)],
    'Dragon': [Color(0xff53a4cf), Color(0xfff16e57)],
    'Dark': [Color(0xff707070), Color(0xff707070)],
    'Fairy': [Color(0xfffdb9e9), Color(0xfffdb9e9)],
    'Normal': [Color(0xffa4acaf), Color(0xffa4acaf)],
    'Fighting': [Color(0xffd56723), Color(0xffd56723)],
    'Flying': [Color(0xff3dc7ef), Color(0xffbdb9b8)],
    'Poison': [Color(0xffb97fc9), Color(0xffb97fc9)],
    'Ground': [Color(0xfff7de3f), Color(0xffab9842)],
    'Rock': [Color(0xffa38c21), Color(0xffa38c21)],
    'Bug': [Color(0xff729f3f), Color(0xff729f3f)],
    'Ghost': [Color(0xff7b62a3), Color(0xff7b62a3)],
    'Steel': [Color(0xff9eb7b8), Color(0xff9eb7b8)],
  };
  List<Color> getTypeColor(String type) => _typeColorMap[type];

  final Map<Region, Map<String, int>> _regionNumberMap = {
    Region.Kanto: {'start': 1, 'end': 151},
    Region.Johto: {'start': 151, 'end': 251},
    Region.Hoenn: {'start': 251, 'end': 386},
    Region.Sinnoh: {'start': 386, 'end': 493},
    Region.Unova: {'start': 493, 'end': 649},
    Region.Kalos: {'start': 649, 'end': 721},
    Region.Alola: {'start': 721, 'end': 809},
  };
  int getStart(Region region) => _regionNumberMap[region]['start'];
  int getEnd(Region region) => _regionNumberMap[region]['end'];

  String maskId(int i) {
    if (i < 10) {
      return '00' + i.toString();
    } else if (i < 100) {
      return '0' + i.toString();
    } else {
      return i.toString();
    }
  }

  String stripEnum(enumerator) {
    return enumerator.toString().split('.')[1];
  }

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
}
