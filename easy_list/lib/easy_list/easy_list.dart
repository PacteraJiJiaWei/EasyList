import 'package:flutter/material.dart';
import 'package:easy_list/easy_list/easy_list_config.dart';
export 'package:easy_list/easy_list/easy_list_config.dart';
import 'package:easy_list/easy_list/easy_list_refresh_footer.dart';
import 'package:easy_list/easy_list/easy_list_refresh_header.dart';

/// 列表属性
typedef EasyListRowCount = int Function(int section);
typedef EasyListSectionSpread = bool Function(int section);
typedef EasyListSectionItemType = EasyListSectionType Function(int section);
typedef EasyListBuildGroupMargin = EasyListGroupMargin Function(int section);
typedef EasyListRowItem = Widget Function(BuildContext context, EasyListIndexPath indexPath);
typedef EasyListSectionItem = Widget Function(BuildContext context, int section);
typedef EasyListSectionFooter = Widget Function(BuildContext context, int section);
typedef EasyListHeaderItem = Widget Function(
  BuildContext context,
);
typedef EasyListFooterItem = Widget Function(
  BuildContext context,
);

/// 刷新控件属性
typedef EasyListRefreshCompere = Function(BuildContext context);
typedef EasyListRefreshHeaderItem = Widget Function(BuildContext context, RefreshState state, double offset);
typedef EasyListRefreshFooterItem = Widget Function(BuildContext context, LoadState state, double offset);
typedef EasyListRefreshSliverItem = Widget Function(BuildContext context, int index);

class EasyList extends StatefulWidget {
  /// 设置当前控件高度，如果不传，默认父控件高度
  final double height;

  /// 设置当前控件宽度，如果不传，默认父控件宽度
  final double width;

  /// 设置当前table的背景颜色
  final Color color;

  /// 滑动控制器
  final ScrollController controller;

  /// 设置当前table的section是否自动展开收起(默认false)
  final bool autoSpread;

  /// 设置当前table的section的数量
  final int sectionCount;

  /// 设置当前section对应的row的数量
  final EasyListRowCount rowCount;

  /// 设置当前row对应的视图
  final EasyListRowItem row;

  /// 设置当前section_header对应的视图
  final EasyListSectionItem sectionHeader;

  /// 设置当前section_footer对应的视图
  final EasyListSectionFooter sectionFooter;

  /// 设置当前section的展开状态
  final EasyListSectionSpread sectionSpread;

  /// 设置当前table的header对应的视图
  final EasyListHeaderItem header;

  /// 设置当前table的footer对应的视图
  final EasyListFooterItem footer;

  /// 设置当前section的Type(normal, group)
  final EasyListSectionItemType sectionType;

  /// 设置当前group模块上，下，左，右的间距
  final EasyListBuildGroupMargin groupMargin;

  /// 下拉刷新回调
  final EasyListRefreshCompere refresh;

  /// 下拉刷新状态变化距离
  final double refreshExtent;

  /// 下拉刷新自定义视图
  final EasyListRefreshHeaderItem refreshHeader;

  /// 上拉加载回调
  final EasyListRefreshCompere load;

  /// 上拉加载状态变化距离
  final double loadExtent;

  /// 上拉加载自定义视图
  final EasyListRefreshFooterItem refreshFooter;

  /// 刷新listItem
  final EasyListRefreshSliverItem item;

  /// 子控件数量
  final int itemCount;

  EasyList({
    Key key,
    this.height,
    this.width,
    this.color = Colors.black12,
    this.controller,
    this.autoSpread,
    this.sectionCount = 1,
    this.rowCount,
    this.row,
    this.sectionHeader,
    this.sectionFooter,
    this.sectionSpread,
    this.header,
    this.footer,
    this.sectionType,
    this.groupMargin,
    this.refresh,
    this.refreshExtent = 60.0,
    this.refreshHeader,
    this.load,
    this.loadExtent = 40.0,
    this.refreshFooter,
    this.item,
    this.itemCount,
  })  : assert(rowCount != null, '需要通过rowCount来设置当前section的row的数量，不能为空'),
        assert(autoSpread == null || sectionSpread == null, 'autoSpread属性与sectionSpread属性冲突，不能一起使用'),
        super(key: key);

  @override
  _EasyListState createState() => _EasyListState();

  /// 用来获取当前的state
  static _EasyListState of(BuildContext context) {
    return context.findAncestorStateOfType<_EasyListState>();
  }
}

class _EasyListState extends State<EasyList> {
  /// 记录坐标数组
  List<EasyListIndexPath> indexPaths;

  /// 记录展开状态数组
  List<bool> isSpreads = List();

  /// 用于校验数组
  List<int> rows = List();

  /// 是否是内部自动展开
  bool spread = false;

  /// 滑动控制器
  ScrollController controller;

  /// 可滑动的最大距离
  double scrollMaxExtent = 0.0;

  /// 下拉刷新state
  ValueNotifier<RefreshState> refreshStateNotifier;

  /// 上拉加载state
  ValueNotifier<LoadState> loadStateNotifier;

  /// header监听滑动距离
  ValueNotifier<double> headerOffsetNotifier;

  /// footer监听滑动距离
  ValueNotifier<double> footerOffsetNotifier;

  /// widget列表
  List<Widget> slivers = List();

  @override
  void initState() {
    super.initState();

    // 初始化rows数组
    compareReload();
    // 创建indexPath的数组
    setUpIndexPaths();
    // 如果需要下拉刷新或上拉加载，自行创建控制器
    if (widget.refresh != null || widget.load != null)
      controller = widget.controller != null ? widget.controller : ScrollController();
    // 如果需要下拉刷新，创建下拉刷新所需要的属性
    if (widget.refresh != null) {
      refreshStateNotifier = ValueNotifier<RefreshState>(RefreshState.cancelRefresh);
      headerOffsetNotifier = ValueNotifier<double>(0.0);
    }
    // 如果需要上拉加载，创建上拉加载所需要的属性
    if (widget.load != null) {
      loadStateNotifier = ValueNotifier<LoadState>(LoadState.cancelLoad);
      footerOffsetNotifier = ValueNotifier<double>(0.0);
    }
  }

  /// 手动刷新列表
  reload() {
    setState(() {
      compareReload();
      setUpIndexPaths();
    });
  }

  /// 判断是否需要整体刷新数据
  bool compareReload() {
    // 是否要刷新数据
    bool reload = false;
    // 是否要初始化数组
    bool initList = false;

    // 获取section的数量
    int sections = widget.sectionCount;
    if (rows.length != sections) {
      rows = List();
      initList = true;
    }
    reload = initList;

    for (int i = 0; i < sections; i++) {
      // 获取每个section对应的row的数量
      int rowNum = widget.rowCount(i);
      if (initList) {
        rows.add(rowNum);
      } else {
        if (rows[i] != rowNum) {
          rows[i] = rowNum;
          reload = true;
        }
      }
    }
    return reload;
  }

  /// 设置坐标数组
  setUpIndexPaths() {
    // 初始化展开列表数组/indexPaths数组
    if (!spread) {
      isSpreads = List();
      spread = false;
    }
    indexPaths = List();

    // 添加header
    if (widget.header != null) {
      EasyListIndexPath sectionIndexPath = EasyListIndexPath(section: 0, row: 0, type: EasyListItemType.header);
      indexPaths.add(sectionIndexPath);
    }

    // 判断是否缓存了展开状态数据
    bool isNull = isSpreads.length == 0;

    for (int i = 0; i < rows.length; i++) {
      EasyListSectionType type = widget.sectionType != null ? widget.sectionType(i) : EasyListSectionType.normal;
      // 添加section_header对应的indexPath
      EasyListIndexPath sectionIndexPath = EasyListIndexPath(
          section: i,
          row: 0,
          type: type == EasyListSectionType.group
              ? EasyListItemType.group_section_header
              : EasyListItemType.section_header);
      indexPaths.add(sectionIndexPath);

      // 获取当前section是否是展开状态,如果不展开，不添加对应的rowItems
      bool isSpread = true;
      if (widget.autoSpread == true) {
        if (isNull) {
          isSpreads.add(isSpread);
        } else {
          isSpread = isSpreads[i];
        }
      } else {
        if (widget.sectionSpread != null) {
          isSpread = widget.sectionSpread(i);
        }
      }

      if (isSpread == true) {
        for (int j = 0; j < rows[i]; j++) {
          // 添加row对应的indexPath
          EasyListIndexPath rowIndexPath = EasyListIndexPath(
            section: i,
            row: j,
            type: type == EasyListSectionType.group ? EasyListItemType.group_row : EasyListItemType.row,
          );
          indexPaths.add(rowIndexPath);
        }
      }

      // 添加section_footer对应的indexPath
      EasyListIndexPath rowIndexPath = EasyListIndexPath(
        section: i,
        row: 1,
        type:
            type == EasyListSectionType.group ? EasyListItemType.group_section_footer : EasyListItemType.section_footer,
      );
      indexPaths.add(rowIndexPath);
    }

    // 添加footer
    if (widget.footer != null) {
      EasyListIndexPath sectionIndexPath = EasyListIndexPath(section: 0, row: 0, type: EasyListItemType.footer);
      indexPaths.add(sectionIndexPath);
    }
  }

  /// 手指离开屏幕时调用
  startRefresh(BuildContext context) {
    if (refreshStateNotifier.value == RefreshState.refreshing) return; // 防止多次点击
    if (controller.offset > -widget.refreshExtent) {
      refreshStateNotifier.value = RefreshState.cancelRefresh;
    } else {
      refreshStateNotifier.value = RefreshState.refreshing;
      if (widget.refresh != null) widget.refresh(context);
    }
  }

  /// 停止刷新回调
  stopRefresh() {
    refreshStateNotifier.value = RefreshState.cancelRefresh;
  }

  /// 滑动时更新state调用
  updateRefresh() {
    if (refreshStateNotifier.value == RefreshState.refreshing) return; // 如果在刷新中不改变刷新状态
    if (controller.offset > -widget.refreshExtent) {
      if (refreshStateNotifier.value == RefreshState.willRefresh)
        refreshStateNotifier.value = RefreshState.cancelRefresh;
    } else {
      if (refreshStateNotifier.value == RefreshState.cancelRefresh)
        refreshStateNotifier.value = RefreshState.willRefresh;
    }
  }

  /// 手指离开屏幕时调用
  startLoad(BuildContext context) {
    if (loadStateNotifier.value == LoadState.loading || loadStateNotifier.value == LoadState.noMore) return; // 防止多次点击
    if (controller.offset < scrollMaxExtent + widget.loadExtent) {
      loadStateNotifier.value = LoadState.cancelLoad;
    } else {
      loadStateNotifier.value = LoadState.loading;
      if (widget.load != null) widget.load(context);
    }
  }

  /// 停止加载回调
  stopLoad() {
    loadStateNotifier.value = LoadState.cancelLoad;
  }

  /// 停止加载回调
  stopLoadNoMore() {
    loadStateNotifier.value = LoadState.noMore;
  }

  /// 滑动时更新state调用
  updateLoad() {
    if (controller.offset < scrollMaxExtent + widget.loadExtent) {
      if (loadStateNotifier.value == LoadState.willLoad) loadStateNotifier.value = LoadState.cancelLoad;
    } else {
      if (loadStateNotifier.value == LoadState.cancelLoad) loadStateNotifier.value = LoadState.willLoad;
    }
  }

  /// 创建视图
  setUpSlivers() {
    slivers.clear();
    // 判断是否需要下拉刷新
    if (widget.refresh != null) {
      Widget header = EasyListRefreshHeader(
          offsetNotifier: headerOffsetNotifier,
          refreshStateNotifier: refreshStateNotifier,
          refreshExtent: widget.refreshExtent,
          child: (context, offset) {
            if (widget.refreshHeader != null) return widget.refreshHeader(context, refreshStateNotifier.value, offset);
            return SizedBox();
          });
      slivers.add(header);
    }

    // 添加列表视图
    Widget list = SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          // 获取到当前item对应的indexPath
          EasyListIndexPath currentIndexPath = indexPaths[index];
          // 获取group的外间距
          EasyListGroupMargin margin =
              widget.groupMargin != null ? widget.groupMargin(currentIndexPath.section) : EasyListGroupMargin();

          // 根据indexPath的row属性来判断section/row/header/footer
          switch (currentIndexPath.type) {

            // section_header
            case EasyListItemType.section_header:
              return GestureDetector(
                onTap: () {
                  // 判断是否自动展开
                  if (widget.autoSpread != true) return;
                  // 判断展开记录状态
                  bool currentState = isSpreads[currentIndexPath.section];
                  // 修改对应展开状态
                  isSpreads[currentIndexPath.section] = !currentState;
                  spread = true;
                  setState(() {
                    // 重新生成坐标数组
                    setUpIndexPaths();
                  });
                },
                // 如果没有设置section对应的widget，默认SizedBox()占位
                child:
                    widget.sectionHeader == null ? SizedBox() : widget.sectionHeader(context, currentIndexPath.section),
              );

            // section_footer
            case EasyListItemType.section_footer:
              return widget.sectionFooter == null
                  ? SizedBox()
                  : widget.sectionFooter(context, currentIndexPath.section);

            // header
            case EasyListItemType.header:
              return widget.header == null ? SizedBox() : widget.header(context);

            // footer
            case EasyListItemType.footer:
              return widget.footer == null ? SizedBox() : widget.footer(context);

            // 内嵌group的section_header
            case EasyListItemType.group_section_header:
              return Container(
                color: Colors.transparent,
                margin: EdgeInsets.only(
                  left: margin.left,
                  right: margin.right,
                  top: margin.top,
                ),
                child: GestureDetector(
                  onTap: () {
                    // 判断是否自动展开
                    if (widget.autoSpread != true) return;
                    // 判断展开记录状态
                    bool currentState = isSpreads[currentIndexPath.section];
                    // 修改对应展开状态
                    isSpreads[currentIndexPath.section] = !currentState;
                    spread = true;
                    setState(() {
                      // 重新生成坐标数组
                      setUpIndexPaths();
                    });
                  },
                  // 如果没有设置section对应的widget，默认SizedBox()占位
                  child: widget.sectionHeader == null
                      ? SizedBox()
                      : widget.sectionHeader(context, currentIndexPath.section),
                ),
              );

            // 内嵌group的section_footer
            case EasyListItemType.group_section_footer:
              return Container(
                color: Colors.transparent,
                margin: EdgeInsets.only(
                  left: margin.left,
                  right: margin.right,
                  bottom: margin.bottom,
                ),
                child:
                    widget.sectionFooter == null ? SizedBox() : widget.sectionFooter(context, currentIndexPath.section),
              );

            // 内嵌group的row
            case EasyListItemType.group_row:
              return Container(
                color: Colors.transparent,
                margin: EdgeInsets.only(
                  left: margin.left,
                  right: margin.right,
                ),
                child: widget.row == null ? SizedBox() : widget.row(context, currentIndexPath),
              );

            // row
            case EasyListItemType.row:
              return widget.row == null ? SizedBox() : widget.row(context, currentIndexPath);

            default:
              return SizedBox();
          }
        },
        childCount: indexPaths.length,
      ),
    );
    slivers.add(list);

    // 判断是否需要上拉加载视图
    if (widget.load != null) {
      Widget footer = EasyListRefreshFooter(
          scrollMaxExtent: scrollMaxExtent,
          offsetNotifier: footerOffsetNotifier,
          loadStateNotifier: loadStateNotifier,
          loadExtent: widget.loadExtent,
          child: (context, offset) {
            if (widget.refreshFooter != null) return widget.refreshFooter(context, loadStateNotifier.value, offset);
            return SizedBox();
          });
      slivers.add(footer);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 如果没有设置宽高,会自动填满
    double height = widget.height == null ? MediaQuery.of(context).size.height : widget.height;
    double width = widget.width == null ? MediaQuery.of(context).size.width : widget.width;

    if (compareReload()) {
      // 设置每个item对应的indexPath
      setUpIndexPaths();
    }

    return Builder(
      builder: (context) {
        // 创建基本视图
        setUpSlivers();
        return Container(
          width: width,
          height: height,
          color: widget.color,
          child: Listener(
            onPointerUp: (event) {
              // 如果没有controller，不需要走下面逻辑
              if (controller == null) return;
              // 监听手指抬起时
              if (controller.offset < 0.0 && widget.refresh != null) startRefresh(context);
              if (controller.offset > scrollMaxExtent && widget.load != null) startLoad(context);
            },
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notification) {
                // 如果没有controller，不需要走下面逻辑
                if (controller == null) return true;
                // 监听controller滑动
                if (notification is ScrollStartNotification) {
                  // 保存最大滚动范围
                  scrollMaxExtent = notification.metrics.maxScrollExtent;
                } else if (notification is ScrollUpdateNotification) {
                  // 监听滑动距离
                  if (controller.offset < 0.0 && widget.refresh != null) {
                    // 触发了下拉刷新
                    updateRefresh();
                    headerOffsetNotifier.value = controller.offset.abs();
                  } else if (controller.offset > scrollMaxExtent && widget.load != null) {
                    // 触发了上拉加载
                    updateLoad();
                    footerOffsetNotifier.value = controller.offset - scrollMaxExtent;
                  }
                }
                return true;
              },
              child: CustomScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                controller: controller,
                slivers: slivers,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.controller != null) widget.controller.dispose();
    if (controller != null) controller.dispose();
    if (headerOffsetNotifier != null) headerOffsetNotifier.dispose();
    if (footerOffsetNotifier != null) footerOffsetNotifier.dispose();
    if (refreshStateNotifier != null) refreshStateNotifier.dispose();
    if (loadStateNotifier != null) loadStateNotifier.dispose();
  }
}
