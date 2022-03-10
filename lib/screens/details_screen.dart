import 'package:dex/data/monster.dart';
import 'package:dex/util/constants.dart';
import 'package:dex/util/dex_provider.dart';
import 'package:dex/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DetailsScreen extends StatefulWidget {
  final Monster monster;

  DetailsScreen({Key key, @required this.monster});

  @override
  _DetailsScreenState createState() => _DetailsScreenState(monster: monster);
}

class _DetailsScreenState extends State<DetailsScreen> with Util {
  Monster monster;
  List<Monster> monsters;
  PageController pageController;
  bool showForm;
  int formNumber;
  String name;
  String desc;
  List types;

  _DetailsScreenState({this.monster});

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    monsters = DexProvider.of(context).dex.currentDex;
    pageController = PageController(initialPage: monsters.indexOf(monster));
    showForm = false;
    formNumber = -1;
    name = monster.name;
    desc = monster.description;
    types = monster.types;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        controller: pageController,
        itemCount: monsters.length,
        itemBuilder: (context, index) {
          monster = monsters[index];
          name = monster.name;
          desc = monster.description;
          types = monster.types;
          return createInfo(index);
        },
      ),
    );
  }

  Widget createInfo(index) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(monster.hexColor), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.center,
        ),
        color: Color(monster.hexColor),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: getTypePills(types),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'No. ${monster.id}',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Center(
                    child: Hero(
                      tag: monster.id,
                      child: Image.asset(
                        getImagePath(monster.id, monster.formId),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BackButton(
                      onPressed: () => Navigator.of(context).pop(index.toDouble()),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topRight,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          name,
                          style: TextStyle(fontSize: 50),
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        kDefaultDivider(Colors.grey.shade400),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 20,
                          ),
                          child: Text(
                            desc,
                            style: textTheme(context).caption,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        kDefaultDivider(Colors.grey.shade400),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            if (monster.forms.isNotEmpty) {
                              setState(() {
                                monster.formId++;
                                if (monster.formId >= monster.forms.length) {
                                  showForm = false;
                                  monster.formId = -1;
                                  name = monster.name;
                                  desc = monster.description;
                                  types = monster.types;
                                } else {
                                  name = monster.forms[monster.formId]['name'];
                                  desc = monster.forms[monster.formId]['description'];
                                  types = monster.forms[monster.formId]['types'];
                                }
                                //types = monster.forms[formNumber]['types'];
                              });
                            }
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
