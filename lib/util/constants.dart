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

Divider kDefaultDivider(color) => Divider(
      thickness: 1,
      indent: 40,
      endIndent: 40,
      height: 5,
      color: color,
    );

const int kTotalPokemon = 809;

const kInputTextDecoration = InputDecoration(
  hintText: 'Search for $kPokemonString',
  hintStyle: TextStyle(
    color: Colors.white60,
  ),
);

const String kDexJsonPath = 'assets/data/dex_5.json';
const String kImagesPath = 'assets/images/pokemon/';
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
  'All': [Color(0x88fd7d24), Color(0xfffd7d24)],
  'Fire': [Color(0x88fd7d24), Color(0xfffd7d24)],
  'Water': [Color(0x884592c4), Color(0xff4592c4)],
  'Grass': [Color(0x889bcc50), Color(0xff9bcc50)],
  'Electric': [Color(0x88eed535), Color(0xffeed535)],
  'Psychic': [Color(0x88f366b9), Color(0xfff366b9)],
  'Ice': [Color(0x8851c4e7), Color(0xff51c4e7)],
  'Dragon': [Color(0xee53a4cf), Color(0xeef16e57)],
  'Dark': [Color(0x88707070), Color(0xff707070)],
  'Fairy': [Color(0x88fdb9e9), Color(0xfffdb9e9)],
  'Normal': [Color(0x88a4acaf), Color(0xffa4acaf)],
  'Fighting': [Color(0x88d56723), Color(0xffd56723)],
  'Flying': [Color(0xff3dc7ef), Color(0xffbdb9b8)],
  'Poison': [Color(0x88b97fc9), Color(0xffb97fc9)],
  'Ground': [Color(0xfff7de3f), Color(0xffab9842)],
  'Rock': [Color(0x88a38c21), Color(0xffa38c21)],
  'Bug': [Color(0x88729f3f), Color(0xff729f3f)],
  'Ghost': [Color(0x887b62a3), Color(0xff7b62a3)],
  'Steel': [Color(0x889eb7b8), Color(0xff9eb7b8)],
};
