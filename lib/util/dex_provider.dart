import 'package:dex/data/filter_keys.dart';
import 'package:dex/data/monster.dart';
import 'package:dex/data/region.dart';
import 'package:dex/data/type.dart';
import 'package:dex/util/dex_loader.dart';
import 'package:flutter/material.dart';

class DexProvider extends InheritedWidget {
  DexProvider({Key key, Widget child, this.dex}) : super(key: key, child: child);
  final DexLoader dex;
  final FilterKeys filter = FilterKeys(regions: [Region.All], types: [Type.All]);
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  Future<List<Monster>> load() => dex.loadDex(filter);

  static DexProvider of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<DexProvider>();
}
