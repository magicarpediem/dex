import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

import '../util/util.dart';

class FuturePaletteGenerator with Util {
  Future<PaletteGenerator> updatePaletteGenerator(int id) async {
    PaletteGenerator paletteGenerator;
    Size size = Size.square(475);
    paletteGenerator = await PaletteGenerator.fromImageProvider(
      AssetImage(getLargeImagePath(id)),
      size: size,
      region: Offset.zero & size,
      maximumColorCount: 20,
    );
    return paletteGenerator;
  }
}
