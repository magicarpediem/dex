import 'dart:convert';

import 'package:dex/data/filter.dart';
import 'package:dex/data/monster.dart';
import 'package:dex/data/region.dart';
import 'package:dex/data/type.dart';
import 'package:dex/util/constants.dart';
import 'package:dex/util/util.dart';
import 'package:flutter/services.dart' show rootBundle;

class DexLoader with Util {
  int monsterCount = kTotalPokemon;
  List<Monster> completeDex = List<Monster>();

  Future<List<Monster>> loadDex(Filter filter) async {
    List<Monster> output = [];
    String jsonStr = await rootBundle.loadString(kDexJsonPath);
    List jsonList = json.decode(jsonStr);
    jsonList.forEach((element) => output.add(Monster.fromJson(element)));
    completeDex.addAll(output);

    if (filter.searchQuery != null && filter.searchQuery.length > 0) {
      String search = filter.searchQuery.toLowerCase();
      if (isAlpha(search)) {
        List<Monster> _allMonsters = output;
        output = _allMonsters
            .where(
              (entry) => entry.name.toLowerCase().startsWith(search),
            )
            .toList();
        output.addAll(_allMonsters
            .where(
              (entry) => entry.name.toLowerCase().contains(search) && !entry.name.toLowerCase().startsWith(search),
            )
            .toList());
      } else if (isNumeric(search)) {
        output = output
            .where(
              (entry) => entry.id == int.parse(search),
            )
            .toList();
      } else {
        output = List<Monster>();
      }
    } else {
      if (filter.region != Region.All) {
        output = output
            .where(
              (entry) => entry.id >= getStart(filter.region) && entry.id <= getEnd(filter.region),
            )
            .toList();
      }
      if (filter.type != Type.All) {
        output = output
            .where(
              (entry) => entry.types.contains(stripEnum(filter.type)),
            )
            .toList();
      }
    }
    monsterCount = output.length;
    return output;
  }
}
