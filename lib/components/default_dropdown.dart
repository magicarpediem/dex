import 'package:dex/util/util.dart';
import 'package:flutter/material.dart';

class Dropdown extends StatelessWidget with Util {
  final dynamic selection;
  final List options;
  final Function onSelect;

  Dropdown({this.selection, this.options, this.onSelect});
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        value: selection,
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.white,
        ),
        iconSize: 20,
        elevation: 16,
        style: textTheme(context).subtitle1,
        isDense: true,
        onChanged: onSelect,
        items: options.map<DropdownMenuItem>((value) {
          return DropdownMenuItem(value: value, child: Text(stripEnum(value)));
        }).toList(),
      ),
    );
  }
}
