import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_list/easy_list/easy_list_config.dart';
import 'dart:math';

class EasyListRefreshNormalHeader extends StatefulWidget {
  final RefreshState refreshState;
  final double offset;

  EasyListRefreshNormalHeader({
    Key key,
    this.refreshState,
    this.offset,
  });

  @override
  _EasyListRefreshNormalHeaderState createState() => _EasyListRefreshNormalHeaderState();
}

class _EasyListRefreshNormalHeaderState extends State<EasyListRefreshNormalHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: widget.refreshState == RefreshState.refreshing
                ? CupertinoActivityIndicator(
                    radius: 12,
                  )
                : SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(
                      value: max(widget.offset - 30.0, 0.0) / 30.0,
                      strokeWidth: 2.0,
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                    ),
                  ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.refreshState == RefreshState.refreshing
                    ? '正在刷新...'
                    : widget.refreshState == RefreshState.willRefresh ? '可以松手了哦' : '下拉刷新数据',
                style: TextStyle(fontSize: 14.0, color: Colors.black),
              ),
              Text(
                '2020-04-30 09:50',
                style: TextStyle(fontSize: 12.0, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
