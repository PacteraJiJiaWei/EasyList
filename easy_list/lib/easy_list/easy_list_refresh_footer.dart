import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'easy_list_config.dart';
import 'easy_list_refresh_normal_footer.dart';

typedef EasyListRefreshAnimationFooter = Widget Function(BuildContext context, double offset);

class EasyListRefreshFooter extends StatefulWidget {
  final EasyListRefreshAnimationFooter child;
  final double loadExtent;
  final ValueNotifier<LoadState> loadStateNotifier;
  final ValueNotifier<double> offsetNotifier;
  final double scrollMaxExtent;

  EasyListRefreshFooter({
    Key key,
    this.child,
    this.loadExtent,
    this.loadStateNotifier,
    this.offsetNotifier,
    this.scrollMaxExtent,
  });

  @override
  _EasyListRefreshFooterState createState() => _EasyListRefreshFooterState();
}

class _EasyListRefreshFooterState extends State<EasyListRefreshFooter> {
  double currentOffset;
  Widget currentFooter;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.loadStateNotifier,
      builder: (context, value, child) {
        return _EasyListRefreshSliverLoad(
          load:
              widget.loadStateNotifier.value == LoadState.loading || widget.loadStateNotifier.value == LoadState.noMore,
          loadExtent: widget.loadExtent,
          child: Builder(
            builder: (context) {
              return Container(
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: ValueListenableBuilder(
                          valueListenable: widget.offsetNotifier,
                          builder: (context, value, child) {
                            if (currentFooter == null) currentFooter = widget.child(context, value);
                            if (currentFooter is SizedBox) {
                              return EasyListRefreshNormalFooter(
                                loadState: widget.loadStateNotifier.value,
                                offset: value,
                              );
                            } else {
                              if (currentOffset != value || widget.loadStateNotifier.value == LoadState.noMore) {
                                currentOffset = value;
                                currentFooter = widget.child(context, value);
                              }
                              return currentFooter;
                            }
                          }),
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _EasyListRefreshSliverLoad extends SingleChildRenderObjectWidget {
  final bool load;
  final double loadExtent;

  const _EasyListRefreshSliverLoad({
    Key key,
    Widget child,
    this.load = false,
    this.loadExtent,
  }) : super(key: key, child: child);

  @override
  _RenderEasyListRefreshSliverLoad createRenderObject(BuildContext context) {
    return _RenderEasyListRefreshSliverLoad(
      load: load,
      loadExtent: loadExtent,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderEasyListRefreshSliverLoad renderObject) {
    renderObject
      ..load = load
      ..loadExtent = loadExtent;
  }
}

class _RenderEasyListRefreshSliverLoad extends RenderSliverSingleBoxAdapter {
  _RenderEasyListRefreshSliverLoad({
    @required bool load,
    @required double loadExtent,
    RenderBox item,
  }) {
    this.child = item;
    _load = load;
    _loadExtent = loadExtent;
  }

  /// 加载状态
  bool get load => _load;
  bool _load;
  set load(bool value) {
    if (value == _load) return;
    _load = value;
    markNeedsLayout();
  }

  /// child高度
  double get loadExtent => _loadExtent;
  double _loadExtent;
  set loadExtent(double value) {
    if (value == _loadExtent) return;
    _loadExtent = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    /// 设置滑动时控件的高度
    geometry = SliverGeometry(
      scrollExtent: _load ? _loadExtent : 0.0,
      paintOrigin: 0.0,
      paintExtent: constraints.remainingPaintExtent,
      maxPaintExtent: constraints.remainingPaintExtent,
      layoutExtent: constraints.remainingPaintExtent,
    );

    /// 设置刷新控件的高度
    child.layout(
      constraints.asBoxConstraints(
        maxExtent: constraints.remainingPaintExtent,
      ),
      parentUsesSize: true,
    );
  }
}
