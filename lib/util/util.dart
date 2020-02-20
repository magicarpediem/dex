import 'package:flutter/material.dart';

mixin Util {
  static const String appTitle = 'Pok\u00e9dex';
  static const String dexJsonPath = 'assets/data/dex.json';
  static const String _smallImagesPath = 'assets/images/pokemon/small/';
  static const String _largeImagesPath = 'assets/images/pokemon/large/';

  static const Map<String, List<Color>> _typeColorMap = {
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

  String maskId(int i) {
    if (i < 10) {
      return '00' + i.toString();
    } else if (i < 100) {
      return '0' + i.toString();
    } else {
      return i.toString();
    }
  }

  String getSmallImagePath(int i) => '$_smallImagesPath${maskId(i)}.png';
  String getLargeImagePath(int i) => '$_largeImagesPath${maskId(i)}.png';
}
