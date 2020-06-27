import 'package:dex/components/toggle_buttons.dart';
import 'package:dex/data/filter_keys.dart';
import 'package:dex/data/region.dart';
import 'package:dex/data/type.dart';
import 'package:dex/util/dex_provider.dart';
import 'package:dex/util/util.dart';
import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> with Util {
  @override
  Widget build(BuildContext context) {
    FilterKeys filter = DexProvider.of(context).filter;
    return Dialog(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text('Region'),
          WrappedToggleButtons(values: Region.values, selectedValues: filter.regions),
          Text('Type'),
          WrappedToggleButtons(values: Type.values, selectedValues: filter.types),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                onPressed: () {},
                child: Text('Advanced'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      filter.regions = [Region.All];
                      filter.types = [Type.All];
                      Navigator.pop(context, true);
                    },
                    child: Text('Reset'),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    textColor: Colors.blue,
                    child: Text('Filter'),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
