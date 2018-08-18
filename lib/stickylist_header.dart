library sticky_header_list;

import 'package:flutter/material.dart';
import 'stickylistrow.dart';
export 'stickylistrow.dart';

typedef StickyListRow StickyWidgetBuilder(BuildContext context, int index);

/// Widget that operates likes [ListView] with type of header rows that
/// sticks to top when scrolled.
///
/// Data for this list are [StickyListRow] : [HeaderRow] and [RegularRow], which
/// are set in list to constructor, or using builder in similar way to
/// ListView builder.
///
/// You should supply height for rows and headers, otherwise GlobalKeys are
/// used to determine height.
///
class StickyList extends StatefulWidget {
  /// Background color of list
  final Color background;
  /// Delegate that builds children widget similar to [SliverChildBuilderDelegate]
  final _StickyChildBuilderDelegate childrenDelegate;

  /// Use this constructor for list of [StickyListRow]
  StickyList({
    Color background: Colors.transparent,
    List<StickyListRow> children: const <StickyListRow>[],
  })
      : childrenDelegate = new _StickyChildBuilderDelegate(children),
        background = background;

  /// This constructor is appropriate for list views with a large (or infinite)
  /// number of children because the builder is called only for those children
  /// that are actually visible.
  StickyList.builder({
    Color background: Colors.transparent,
    int itemCount,
    StickyWidgetBuilder builder
  })
      : childrenDelegate = new _StickyChildBuilderDelegate.builder(
      builder, itemCount), background = background;

  @override
  _StickyListState createState() =>
      new _StickyListState(background: background, delegate: childrenDelegate);
}

class _StickyListState extends State<StickyList> {
  Color _background;
  _StickyChildBuilderDelegate _childrenDelegate;

  /// When new sticky is coming, we use transform (translation) to simulate
  /// that the new sticky header is pushing the old one off the screen.
  var _stickyTranslationOffset = 0.0;

  /// Current position at the top of list
  var _currentPosition = 0;

  _StickyListState({
    Color background,
    _StickyChildBuilderDelegate delegate
  }) {
    this._background = background;
    this._childrenDelegate = delegate;
    this._stickyTranslationOffset = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Stack(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(color: _background),
          ),
          new ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(parent: const BouncingScrollPhysics()),
            itemBuilder: (BuildContext context, int index) {
              return this._childrenDelegate.build(context, index).child;
            },
            itemCount: this._childrenDelegate.itemCount,
            controller: _getScrollController(),
            padding: const EdgeInsets.all(0.0),
          ),
          new Positioned(
            child: _getStickyHeaderWidget(context),
            top: 0.0,
            left: 0.0,
            right: 0.0,
          )
        ],
      ),
    );
  }

  Widget _getStickyHeaderWidget(BuildContext ctx) {
    Widget stickyWidget = new Container();
    if (_currentPosition == -1) {
      // Don't display header for iOS bounce
    } else {
      // Use child widget to avoid duplicate widgets with same global key
      Widget header = _getPreviousHeader(context, _currentPosition - 1);
      if (header is WrapStickyWidget) {
        header = (header as WrapStickyWidget).child;
      }

      stickyWidget = new ClipRect(
          child: new Container(
            child: header,
            transform: new Matrix4.translationValues(
                0.0, -_stickyTranslationOffset, 0.0),
          ));
    }
    return stickyWidget;
  }

  Widget _getPreviousHeader(BuildContext ctx, int position) {
    for (int i = position; i >= 0; i--) {
      if (this._childrenDelegate.build(ctx, i).isSticky()) {
        return this._childrenDelegate.build(ctx, i).child;
      }
    }

    return this._childrenDelegate.build(ctx, 0).child;
  }

  ScrollController _getScrollController() {
    var controller = new ScrollController();
    controller.addListener(() {
      var pixels = controller.offset;
      var newPosition = _getPositionForOffset(context, pixels);

      _calculateStickyOffset(context, newPosition, pixels);
      _calculateNewPosition(pixels, newPosition);
    });
    return controller;
  }

  void _calculateNewPosition(double pixels, int newPosition) {
    if (pixels < 0) {
      setState(() {
        _currentPosition = -1;
      });
    } else if (newPosition != _currentPosition) {
      setState(() {
        _currentPosition = newPosition;
      });
    }
  }

  void _calculateStickyOffset(BuildContext ctx, int newPosition, double pixels) {
    if ((newPosition > 0) && this._childrenDelegate.build(ctx, newPosition).isSticky()) {
      final headerHeight = this._childrenDelegate.build(ctx, newPosition).getHeight();
      if (_getOffsetForCurrentRow(context, pixels, newPosition) < headerHeight) {
        setState(() {
          _stickyTranslationOffset =
              headerHeight - _getOffsetForCurrentRow(context, pixels, newPosition);
        });
      }
    } else {
      if (_stickyTranslationOffset > 0.0) {
        setState(() {
          _stickyTranslationOffset = 0.0;
        });
      }
    }
  }

  double _getOffsetForCurrentRow(BuildContext ctx, double offset, int position) {
    double calcOffset = offset;
    for (var i = 0; i < position - 1; i++) {
      calcOffset = calcOffset - this._childrenDelegate.build(ctx, i).getHeight();
    }

    return (this._childrenDelegate.build(ctx, position-1).getHeight() - calcOffset);
  }

  int _getPositionForOffset(BuildContext ctx, double offset) {
    int counter = 0;
    double calcOffset = offset;

    while (calcOffset > 0) {
      calcOffset = calcOffset - this._childrenDelegate.build(ctx, counter).getHeight();
      counter++;
    }

    return counter;
  }

}

/// Simple widget that just wraps the child. When height is not provided,
/// GlobalKeys are used, and this widget is used to access child and avoid
/// duplicate widget for same GlobalKey (when duplicating header).
class WrapStickyWidget extends StatelessWidget {
  final Widget child;

  WrapStickyWidget({this.child, Key key}):
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

///  A delegate that supplies children for sticky list. It is used in list and
///  builder way. Works similar to [SliverChildBuilderDelegate] that is used
///  by [ListView]
class _StickyChildBuilderDelegate {

  StickyWidgetBuilder stickyBuilder;
  int itemCount;
  List<StickyListRow> children;

  _StickyChildBuilderDelegate(this.children) {
    this.itemCount = children.length;
  }

  _StickyChildBuilderDelegate.builder(this.stickyBuilder, this.itemCount);

  StickyListRow build(BuildContext context, int index) {
    if (stickyBuilder != null) {
      final w = stickyBuilder(context, index);
      return w;
    } else {
      return children[index];
    }
  }

}