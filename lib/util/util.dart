import 'package:dex/components/pill_box.dart';
import 'package:dex/data/region.dart';
import 'package:dex/util/constants.dart';
import 'package:flutter/material.dart';

mixin Util {
  String getImagePath(int id, bool hasForm, int formNumber) {
    return hasForm ? '$kImagesPath${maskId(id)}_f${formNumber + 2}.png' : '$kImagesPath${maskId(id)}.png';
  }

  TextTheme textTheme(context) => Theme.of(context).textTheme;

  List<Color> getTypeColor(String type) => kTypeColorMap[type];

  // Get the starting index of selected region
  int getStart(Region region) => kRegionNumberMap[region]['start'];
  // Get the ending index of selected region
  int getEnd(Region region) => kRegionNumberMap[region]['end'];

  List<Widget> getTypePills(types) => types.map<Widget>((value) {
        return PillBox(label: value);
      }).toList();

  // This is used to mask the ID since the resources are labeled as 3 digits
  String maskId(int i) {
    if (i < 10) {
      return '00' + i.toString();
    } else if (i < 100) {
      return '0' + i.toString();
    } else {
      return i.toString();
    }
  }

  // enums.toString() returns a string with the enum name prefixed like: enumName.value
  // this will strip the prefix
  String stripEnum(enumerator) => enumerator.toString().split('.')[1];

  bool isAlpha(String str) => str.contains(RegExp(r'[A-Za-z]'));
  bool isNumeric(String str) => str.contains(RegExp(r'[0-9]'));

  double calculateOffset(index) {
    double offset = 60 + index * 118;
    offset = offset >= 0 ? offset : 0;
    return offset;
  }

  double calculateIndex(offset) {
    double index = offset - 60;
    index = index >= 0 ? index : 0;
    index = index / 118;
    return index;
  }

  int subjectiveIndex(objectiveIndex, startIndex) => objectiveIndex - startIndex + 1;
  int objectiveIndex(relativeIndex, startIndex) => relativeIndex + startIndex;
}
