import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_list/easy_list/easy_list_config.dart';
import 'dart:math';

class EasyListRefreshNormalFooter extends StatefulWidget {
  final LoadState loadState;
  final double offset;

  EasyListRefreshNormalFooter({
    Key key,
    this.loadState,
    this.offset,
  });

  @override
  _EasyListRefreshNormalFooterState createState() => _EasyListRefreshNormalFooterState();
}

class _EasyListRefreshNormalFooterState extends State<EasyListRefreshNormalFooter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.loadState == LoadState.noMore
              ? SizedBox()
              : Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: widget.loadState == LoadState.loading
                ? CupertinoActivityIndicator(
              radius: 12,
            )
                : SizedBox(
              height: 20.0,
              width: 20.0,
              child: CircularProgressIndicator(
                value: max(widget.offset - 10.0, 0.0) / 30.0,
                strokeWidth: 2.0,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              ),
            ),
          ),
          Text(
            widget.loadState == LoadState.loading
                ? '正在加载...'
                : widget.loadState == LoadState.noMore
                ? '----------暂无更多内容----------'
                : widget.loadState == LoadState.willLoad ? '可以松手了哦' : '上拉加载数据',
            style: TextStyle(fontSize: 14.0, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
