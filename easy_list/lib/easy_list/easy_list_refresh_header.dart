import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:easy_list/easy_list/easy_list_config.dart';
import 'package:easy_list/easy_list/easy_list_refresh_normal_header.dart';
import 'dart:math';

typedef EasyListRefreshAnimationHeader = Widget Function(BuildContext context, double offset);

class EasyListRefreshHeader extends StatefulWidget {
  final EasyListRefreshAnimationHeader child;
  final double refreshExtent;
  final ValueNotifier<RefreshState> refreshStateNotifier;
  final ValueNotifier<double> offsetNotifier;

  EasyListRefreshHeader({
    Key key,
    this.child,
    this.refreshExtent,
    this.refreshStateNotifier,
    this.offsetNotifier,
  });

  @override
  _EasyListRefreshHeaderState createState() => _EasyListRefreshHeaderState();
}

class _EasyListRefreshHeaderState extends State<EasyListRefreshHeader> {
  double currentOffset;
  Widget currentHeader;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.refreshStateNotifier,
      builder: (context, value, child) {
        return _EasyListRefreshSliverRefresh(
          refresh: widget.refreshStateNotifier.value == RefreshState.refreshing,
          refreshExtent: widget.refreshExtent,
          child: Builder(
            builder: (context) {
              return Container(
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: ValueListenableBuilder(
                          valueListenable: widget.offsetNotifier,
                          builder: (context, value, child) {
                            if (currentHeader == null) currentHeader = widget.child(context, value);
                            if (currentHeader is SizedBox) {
                              return EasyListRefreshNormalHeader(
                                refreshState: widget.refreshStateNotifier.value,
                                offset: value,
                              );
                            } else {
                              if (currentOffset != value) {
                                currentOffset = value;
                                currentHeader = widget.child(context, value);
                              }
                              return currentHeader;
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

class _EasyListRefreshSliverRefresh extends SingleChildRenderObjectWidget {
  final bool refresh;
  final double refreshExtent;

  const _EasyListRefreshSliverRefresh({
    Key key,
    Widget child,
    this.refresh = false,
    this.refreshExtent,
  }) : super(key: key, child: child);

  @override
  _RenderEasyListRefreshSliverRefresh createRenderObject(BuildContext context) {
    return _RenderEasyListRefreshSliverRefresh(
      refresh: refresh,
      refreshExtent: refreshExtent,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderEasyListRefreshSliverRefresh renderObject) {
    renderObject
      ..refresh = refresh
      ..refreshExtent = refreshExtent;
  }
}

class _RenderEasyListRefreshSliverRefresh extends RenderSliverSingleBoxAdapter {
  _RenderEasyListRefreshSliverRefresh({
    @required bool refresh,
    @required double refreshExtent,
    RenderBox item,
  }) {
    this.child = item;
    _refresh = refresh;
    _refreshExtent = refreshExtent;
  }

  /// 刷新状态
  bool get refresh => _refresh;
  bool _refresh;
  set refresh(bool value) {
    if (value == _refresh) return;
    _refresh = value;
    markNeedsLayout();
  }

  /// child高度
  double get refreshExtent => _refreshExtent;
  double _refreshExtent;
  set refreshExtent(double value) {
    if (value == _refreshExtent) return;
    _refreshExtent = value;
    markNeedsLayout();
  }

  double layoutExtentOffsetCompensation = 0.0;

  @override
  void performLayout() {
    double refreshHeight = _refresh ? _refreshExtent : 0.0;
    double scrollExtent = constraints.overlap < 0.0 ? constraints.overlap.abs() : 0.0;

    /// 用来做状态切换缓冲
    if (refreshHeight != layoutExtentOffsetCompensation) {
      geometry = SliverGeometry(
        scrollOffsetCorrection: refreshHeight - layoutExtentOffsetCompensation,
      );
      layoutExtentOffsetCompensation = refreshHeight;
      return;
    }

    if (_refresh) {
      /// 设置刷新中的高度
      geometry = SliverGeometry(
        scrollExtent: refreshHeight,
        paintOrigin: -scrollExtent - constraints.scrollOffset,
        paintExtent: min(max(refreshHeight - constraints.scrollOffset, 0.0), constraints.remainingPaintExtent),
        maxPaintExtent: max(refreshHeight - constraints.scrollOffset, 0.0),
        layoutExtent: max(refreshHeight - constraints.scrollOffset, 0.0),
      );
    } else {
      /// 设置未刷新切滑动时的高度
      if (constraints.overlap < 0.0) {
        geometry = SliverGeometry(
          scrollExtent: refreshHeight,
          paintOrigin: -scrollExtent,
          paintExtent: scrollExtent,
          maxPaintExtent: scrollExtent,
          layoutExtent: 0.0,
        );
      } else {
        /// 设置没有滑动时的高度
        geometry = SliverGeometry.zero;
      }
    }

    /// 设置刷新控件的高度
    child.layout(
      constraints.asBoxConstraints(
        maxExtent: refreshHeight + scrollExtent,
      ),
      parentUsesSize: true,
    );
  }
}
