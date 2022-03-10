import 'dart:convert';

import 'package:dex/data/filter_keys.dart';
import 'package:dex/data/monster.dart';
import 'package:dex/data/region.dart';
import 'package:dex/data/type.dart';
import 'package:dex/util/constants.dart';
import 'package:dex/util/util.dart';
import 'package:flutter/services.dart' show rootBundle;

class DexLoader with Util {
  List<Monster> currentDex = List<Monster>();

  // This is what loads the dex from the json and then filters it
  Future<List<Monster>> loadDex(FilterKeys filter) async {
    List<Monster> output = [];
    List<Monster> allMonsters = [];
    // Read json from file into a string
    String jsonStr = await rootBundle.loadString(kDexJsonPath);
    // Convert from json to List object
    List jsonList = json.decode(jsonStr);
    // For every item in jsonList, convert it into a Monster object and add to output
    jsonList.forEach((element) => allMonsters.add(Monster.fromJson(element)));
    output = allMonsters;

    // Filter by search query here
    if (filter.searchQuery != null && filter.searchQuery.length > 0) {
      String search = filter.searchQuery.toLowerCase();
      // If the query is alphabetical, search names
      if (isAlpha(search)) {
        // For every monster whose name starts with the query, add it to the output object
        // This rewrites the original output created at first
        output = allMonsters
            .where(
              (entry) => entry.name.toLowerCase().startsWith(search),
            )
            .toList();
        // For every monster whose name contains the query, add it to the output object
        // This adds to the output instead of rewriting.
        // It's done in this order so that the more accurate results are on top
        // Also the condition !startsWith is there to prevent duplicates
        output.addAll(allMonsters
            .where(
              (entry) => entry.name.toLowerCase().contains(search) && !entry.name.toLowerCase().startsWith(search),
            )
            .toList());
      } else if (isNumeric(search)) {
        // If the  query is numeric, match monsters by ID
        // This will only give back a mon that is an exact match
        output = allMonsters
            .where(
              (entry) => entry.id == int.parse(search),
            )
            .toList();
      } else {
        // If the query is neither alphabetic nor numeric, give back an empty list
        output = List<Monster>();
      }
    } else {
      // Region and Type filters are separated so a search can be done on all pokemon instead of a select few
      // If the region isn't All, return all monsters with the given regions
      List regions = filter.regions;
      if (regions != null && !regions.contains(Region.All)) {
        output = [];
        regions.forEach((region) => output.addAll(allMonsters
            .where(
              (entry) => entry.id >= getStart(region) && entry.id <= getEnd(region),
            )
            .toList()));
      }
      //If the type isn't All, return all monsters with the given types
      List types = filter.types;
      if (types.isNotEmpty && !types.contains(Type.All)) {
        List<Monster> currentResult = output;
        output = [];
        output.addAll(currentResult
            .where(
              (entry) => entry.types.any((type) => types.any((selectedType) => type == stripEnum(selectedType))),
            )
            .toList());
      }
    }
    // currentDex is a cached List of the filtered mons
    // This helps with indexing and remembering where we are in the list for scroll animations
    // This is used because IDs become arbitrary in a filtered list
    currentDex.clear();
    currentDex.addAll(output);

    return output;
  }
}
