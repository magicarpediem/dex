import 'package:flutter/material.dart';

class DraggableScrollbar extends StatefulWidget {
  const DraggableScrollbar({this.child, this.parentController});

  final Widget child;
  final ScrollController parentController;

  @override
  _DraggableScrollbarState createState() => new _DraggableScrollbarState();
}

class _DraggableScrollbarState extends State<DraggableScrollbar> with TickerProviderStateMixin {
  //this counts offset for scroll thumb for Vertical axis
  double _barOffset;
  double _previousPosition;
  // controller for the thing
  AnimationController animationController;
  Animation<double> animation;
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    _barOffset = 0.0;
    _previousPosition = 0.0;
    animationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    scrollController = new ScrollController();
    scrollController.addListener(scrollListener);
  }

  scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent && !scrollController.position.outOfRange) {
      setState(() {
        print('top');
      });
    }
    if (scrollController.offset <= scrollController.position.minScrollExtent && !scrollController.position.outOfRange) {
      setState(() {
        print('bottom');
      });
    }
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _barOffset += details.delta.dy;
      widget.parentController.jumpTo(_barOffset * 200);

      if (_barOffset < 0) {
        _barOffset = 0;
      } else if (_barOffset * 200 > widget.parentController.position.maxScrollExtent) {
        _barOffset = widget.parentController.position.maxScrollExtent / 200;
      }
      _previousPosition = _barOffset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        widget.child,
        ListView.builder(
          itemCount: 1,
          controller: scrollController,
          itemBuilder: (context, index) => GestureDetector(
              onVerticalDragUpdate: _onVerticalDragUpdate,
              child: Container(
                  alignment: Alignment.topRight, margin: EdgeInsets.only(top: _barOffset), child: _buildScrollThumb())),
        ),
      ],
    );
  }

  Widget _buildScrollThumb() {
    return new Container(
      height: 40.0,
      width: 20.0,
      color: Colors.blue,
    );
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }
}
