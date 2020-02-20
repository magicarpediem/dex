import 'dart:async' show Future;
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../data/monster.dart';
import '../util/util.dart';

class FutureDexBuilder {
  Future<List<Monster>> loadDex() async {
    List<Monster> output = [];
    String jsonStr = await rootBundle.loadString(Util.dexJsonPath);
    List jsonList = json.decode(jsonStr);
    jsonList.forEach((element) => output.add(Monster.fromJson(element)));
    return output;
  }
}
