import 'package:flutter/material.dart';

/// 记录坐标类
class EasyListIndexPath {
  /// 组
  int section;

  /// 行
  int row;

  /// 组/行高
  double height;

  /// item类型
  EasyListItemType type;

  EasyListIndexPath({
    Key key,
    this.section,
    this.row,
    this.height,
    this.type,
  });
}

/// item的type类型
enum EasyListItemType {
  header,
  footer,
  section_header,
  section_footer,
  row,
  group_row,
  group_section_header,
  group_section_footer,
}

/// section的type类型
enum EasyListSectionType {
  normal,
  group,
}

/// 记录group模式外间距
class EasyListGroupMargin {
  /// 左间距
  double left;

  /// 右间距
  double right;

  /// 上间距
  double top;

  /// 下间距
  double bottom;

  EasyListGroupMargin({
    Key key,
    this.left = 10.0,
    this.right = 10.0,
    this.top = 10.0,
    this.bottom = 10.0,
  });
}

/// 刷新状态
enum RefreshState {
  willRefresh,
  refreshing,
  cancelRefresh,
}

/// 加载状态
enum LoadState {
  willLoad,
  loading,
  cancelLoad,
  noMore,
}