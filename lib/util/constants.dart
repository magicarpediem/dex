import 'package:dex/data/region.dart';
import 'package:flutter/material.dart';

const String kPokedexString = 'Pok\u00e9dex';
const String kPokemonString = 'Pok\u00e9mon';

const Text kAppTitle = Text(
  kPokedexString,
  style: TextStyle(
    color: Colors.white,
    fontSize: 40,
    fontFamily: 'OdibeeSans',
    letterSpacing: 5,
  ),
);

const int kTotalPokemon = 809;

const kInputTextDecoration = InputDecoration(
  hintText: 'Search for $kPokemonString',
  hintStyle: TextStyle(
    color: Colors.white60,
  ),
);

const String kDexJsonPath = 'assets/data/dex_4.json';
const String kSmallImagesPath = 'assets/images/pokemon/small/';
const String kLargeImagesPath = 'assets/images/pokemon/large/';
final Color kBackgroundColor = Colors.red.shade400;

const Map<Region, Map<String, int>> kRegionNumberMap = {
  Region.Kanto: {'start': 1, 'end': 151},
  Region.Johto: {'start': 152, 'end': 251},
  Region.Hoenn: {'start': 252, 'end': 386},
  Region.Sinnoh: {'start': 387, 'end': 494},
  Region.Unova: {'start': 495, 'end': 649},
  Region.Kalos: {'start': 650, 'end': 721},
  Region.Alola: {'start': 722, 'end': 809},
};

const Map<String, List<Color>> kTypeColorMap = {
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
