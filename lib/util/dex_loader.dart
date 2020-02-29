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

  Future<List<Monster>> loadDex(Filter filter) async {
    List<Monster> output = [];
    String jsonStr = await rootBundle.loadString(kDexJsonPath);
    List jsonList = json.decode(jsonStr);
    jsonList.forEach((element) => output.add(Monster.fromJson(element)));

    if (filter.name != null && filter.name.length > 0) {
      List<Monster> _allMonsters = output;
      String name = filter.name.toLowerCase();
      output = _allMonsters
          .where(
            (entry) => entry.name.toLowerCase().startsWith(name),
          )
          .toList();
      output.addAll(_allMonsters
          .where(
            (entry) => entry.name.toLowerCase().contains(name) && !entry.name.toLowerCase().startsWith(name),
          )
          .toList());
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
