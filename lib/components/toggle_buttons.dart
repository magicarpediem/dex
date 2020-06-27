import 'package:dex/data/region.dart';
import 'package:dex/data/type.dart';
import 'package:dex/util/dex_provider.dart';
import 'package:dex/util/util.dart';
import 'package:flutter/material.dart';

class WrappedToggleButtons extends StatefulWidget {
  final List values;
  final List selectedValues;
  WrappedToggleButtons({Key key, this.values, this.selectedValues});
  @override
  _WrappedToggleButtonsState createState() =>
      _WrappedToggleButtonsState(values: values, selectedValues: selectedValues);
}

class _WrappedToggleButtonsState extends State<WrappedToggleButtons> with Util {
  List values;
  List selectedValues;

  List<bool> isPressed = [];
  List<RaisedButton> buttons = [];

  _WrappedToggleButtonsState({this.values, this.selectedValues});

  @override
  void initState() {
    if (selectedValues.where((e) => e.toString().endsWith('All')).isEmpty) {
      isPressed.add(false);
    } else {
      isPressed.add(true);
    }
    values.sublist(1).forEach((value) {
      isPressed.add(selectedValues.contains(value));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    buttons = [];
    buttons.add(
      RaisedButton(
        color: isPressed[0] ? Colors.blue : Colors.grey,
        onPressed: () {
          setState(() {
            isPressed[0] = true;
            for (int i = 1; i < values.length; i++) {
              isPressed[i] = false;
            }
          });
        },
        child: Text(stripEnum(values[0])),
      ),
    );
    values.sublist(1).forEach(
      (value) {
        int index = values.indexOf(value);
        buttons.add(
          RaisedButton(
            color: isPressed[index] ? Colors.blue : Colors.grey,
            onPressed: () {
              setState(() {
                isPressed[0] = false;
                isPressed[index] = !isPressed[index];
                if (!isPressed.contains(true)) {
                  isPressed[0] = true;
                }
              });
            },
            child: Text(stripEnum(value)),
          ),
        );
      },
    );
    selectedValues = [];
    for (int i = 0; i < isPressed.length; i++) {
      if (isPressed[i]) {
        selectedValues.add(values[i]);
      }
    }
    if (isPressed.sublist(1).contains(true)) {
      selectedValues.removeWhere((e) => e.toString().endsWith('All'));
    } else {
      selectedValues = [values[0]];
    }
    DexProvider dex = DexProvider.of(context);
    if (values is List<Region>) {
      dex.filter.regions = selectedValues;
    }
    if (values is List<Type>) {
      dex.filter.types = selectedValues;
    }
    return Wrap(children: buttons);
  }
}
