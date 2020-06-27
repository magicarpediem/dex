import 'package:dex/util/util.dart';
import 'package:flutter/material.dart';

// Creates a pill shaped container for types

class PillBox extends StatelessWidget with Util {
  final String label;
  final List<Color> colors;

  PillBox({this.label, this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 3),
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
      decoration: BoxDecoration(
        // Linear gradient is mainly for types that have two colors
        // Single color types have an opacity gradient to give a lighter look
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label, style: textTheme(context).body2),
    );
  }
}
