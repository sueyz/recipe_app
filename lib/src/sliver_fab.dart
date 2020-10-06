import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SliverContainer extends StatefulWidget {
  final List<Widget> slivers;
  final Widget floatingActionButton;
  final double expandedHeight;
  final double marginRight;
  final double topScalingEdge;
  final ScrollController scrollController;

  SliverContainer(
      {@required this.slivers,
      @required this.floatingActionButton,
      @required this.scrollController,
      this.expandedHeight = 200.0,
      this.marginRight = 16.0,
      this.topScalingEdge = 107.0}); //for when FAB is transforming

  @override
  State<StatefulWidget> createState() => SliverFabState();
}

class SliverFabState extends State<SliverContainer> {
  // ScrollController scrollController;

  // @override
  // void initState() {
  //   super.initState();
  //   scrollController = ScrollController();
  //   scrollController.addListener(() => setState(() {}));
  // }
  //
  // @override
  // void dispose() {
  //   scrollController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CustomScrollView(
          controller: widget.scrollController,
          slivers: widget.slivers,
        ),
        _buildFab(),
      ],
    );
  }

  Widget _buildFab() {
    // final topMarginAdjustVal =
    //     Theme.of(context).platform == TargetPlatform.iOS ? 12.0 : -4.0;
    final double defaultTopMargin = widget.expandedHeight;

    double top = defaultTopMargin;
    double scale = 1.0;
    double opacity = 1.0;
    if (widget.scrollController.hasClients) {
      double offset = widget.scrollController.offset;
      top -= offset > 0 ? offset : 0;
      opacity = 1.0 - (offset / widget.expandedHeight);
      if (opacity < 0) {
        opacity = 0;
      } else if (opacity > 1) {
        opacity = 1;
      }

      if (offset < defaultTopMargin - widget.topScalingEdge) {
        scale = 1.0;
      } else if (offset < defaultTopMargin - widget.topScalingEdge / 2) {
        scale = (defaultTopMargin - widget.topScalingEdge / 2 - offset) /
            (widget.topScalingEdge / 2);
      } else {
        scale = 0.0;
      }
    }

    return Positioned(
      top: top,
      right: widget.marginRight,
      child: Transform(
          transform: Matrix4.identity()..scale(scale, scale),
          alignment: FractionalOffset.center,
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 10),
            opacity: opacity,
            child: widget.floatingActionButton,
          )),
    );
  }
}
