import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'monster.dart';

Future<List<Monster>> loadDex() async {
  List<Monster> output = [];
  String jsonStr = await rootBundle.loadString('assets/data/dex.json');
  List jsonList = json.decode(jsonStr);
  jsonList.forEach((element) => output.add(Monster.fromJson(element)));
  return output;
}
