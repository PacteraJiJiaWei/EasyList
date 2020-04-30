import 'package:flutter/material.dart';
import 'easy_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Map> dataList = [
      {
        'sectionTitle': '电影',
        'color': Colors.red,
        'type': '2',
        'data': [
          ItemModel(
            type: '2',
            title: '红海行动',
            imgUrl: 'https://p0.meituan.net/movie/4aa41a512c44f4a7d613c05a8d47fbb0411851.jpg@464w_644h_1e_1c',
            message: '剧情 动作\n中国大陆,中国香港 / 138分钟',
            time: '2020-03-25大陆重映',
            price: '200',
          ),
          ItemModel(
            type: '2',
            title: '滚蛋吧肿瘤君',
            imgUrl: 'https://p1.meituan.net/movie/c38c4f34d4063ffbb6c00eab24a952f6148802.jpg@464w_644h_1e_1c',
            message: '剧情 喜剧 爱情\n中国大陆 / 128分钟',
            time: '2020-03-25大陆重映',
            price: '150',
          ),
          ItemModel(
            type: '2',
            title: '白蛇缘起',
            imgUrl: 'https://p0.meituan.net/movie/a48ac62bd6f10b9bf94aebc2f19d24021727296.jpg@464w_644h_1e_1c',
            message: '爱情 动画 奇幻\n中国大陆 / 98分钟',
            time: '2020-03-25大陆重映',
            price: '125',
          ),
          ItemModel(
            type: '2',
            title: '湄公河行动',
            imgUrl: 'https://p0.meituan.net/movie/4a518e347a82d47d7f9a96b3c6c44500344506.jpg@464w_644h_1e_1c',
            message: '剧情 动作 犯罪\n中国大陆,中国香港 / 124分钟',
            time: '2020-03-25大陆重映',
            price: '200',
          ),
          ItemModel(
            type: '2',
            title: '站住小偷',
            imgUrl: 'https://p0.meituan.net/movie/115273d73084aa4e54c3401f7457e9fa1185899.jpg@464w_644h_1e_1c',
            message: '喜剧\n中国大陆 / 96分钟',
            time: '2020-03大陆重映',
            price: '115',
          ),
        ],
      },
      {
        'sectionTitle': '美食',
        'color': Colors.deepOrangeAccent,
        'type': '1',
        'data': [
          ItemModel(
            type: '2',
            title: '精烧细烤',
            imgUrl: 'https://p1.meituan.net/mogu/0bfe3ca3e45f966a81feef03e107d2d6677480.png@380w_214h_1e_1c',
            message: '地址：开发区大连经济技术开发区黄海西路179号\n电话：13238032883',
            time: '营业时间：周一至周日 15:00-02:00',
            price: '100',
          ),
          ItemModel(
            type: '2',
            title: '麻辣频道',
            imgUrl: 'https://img.meituan.net/msmerchant/17eade5c908fb50cfa61c848d9c6e768204879.png@380w_214h_1e_1c',
            message: '地址：中山区解放路亿达云集G4-1-11\n电话：15042477794',
            time: '营业时间：周一至周日 11:00-13:00 16:30-24:00',
            price: '66',
          ),
          ItemModel(
            type: '2',
            title: 'SIGSAUERBAR酒吧·果雨茶',
            imgUrl: 'https://img.meituan.net/msmerchant/d8253c1e2f79abac17a8ad5ab61d6ba1129167.jpg@380w_214h_1e_1c',
            message: '地址：中山区七一街20号\n电话：15668686687/13050517050',
            time: '营业时间：周一至周日 10:00-01:00',
            price: '300',
          ),
        ],
      },
      {
        'sectionTitle': '住宿',
        'color': Colors.orangeAccent,
        'type': '2',
        'data': [
          ItemModel(
            type: '2',
            title: '时尚北欧风，舒适大床房',
            imgUrl: 'https://img.meituan.net/phoenix/886fdcfd6b3054710e652cf707497855407639.jpg@740w_416h_1e_1c',
            message: '济南历城区北园大街全福立交桥西北角',
            time: '',
            price: '80',
          ),
          ItemModel(
            type: '2',
            title: '高新区新泺大街雅居园小区精装主卧拎包入住',
            imgUrl: 'https://img.meituan.net/phoenix/64f5c1f73f5bb09db89d93c94b1f035b345562.jpg@740w_416h_1e_1c',
            message: '济南历下区新泺大街2222号',
            time: '',
            price: '62',
          ),
        ],
      },
    ];

    return MaterialApp(
      title: 'BaseTableDemo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text('EasyList'),
            ),
            body: EasyList(
              color: Color.fromARGB(255, 220, 220, 220),
              groupMargin: (section) {
                return EasyListGroupMargin(left: 10.0, right: 10.0,top: 10.0,bottom: 10.0);
              },
              autoSpread: true,
              sectionCount: dataList.length,
              rowCount: (section) {
                return dataList[section]['data'].length;
              },
              sectionHeader: (context, section) {
                return Container(
                  padding: EdgeInsets.only(
                    left: 10.0,
                  ),
                  height: 40.0,
                  alignment: Alignment.centerLeft,
                  color: dataList[section]['color'],
                  child: Text(
                    dataList[section]['sectionTitle'],
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                );
              },
              sectionFooter: (context, section) {
                return Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(
                    right: 10.0,
                  ),
                  height: 40.0,
                  alignment: Alignment.centerRight,
                  child: Text('查看更多 >'),
                );
              },
              header: (context) {
                return Container(
                  height: 104.0,
                  alignment: Alignment.center,
                  child: Image.network('https://s3plus-img.meituan.net/v1/mss_c4e301e8206f4e56bbb5f4fb85d0d48f/donation-bucket/MDpkb25hdGlvbi1idWNrZXQ656S-5Yy6UEPnq6_pppblm74uanBnOjIwMjAwMjI3MTkzMzA0OjlCcW9NcUEw@1200w_65q',),
                );
              },
              footer: (context) {
                return SizedBox();
              },
              sectionType: (section) {
                return dataList[section]['type'] == '2' ? EasyListSectionType.group : EasyListSectionType.normal;
              },
              row: (context, indexPath) {
                ItemModel model = dataList[indexPath.section]['data'][indexPath.row];
                return Container(
                  height: 130.0,
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    children: <Widget>[
                      Image.network(
                        model.imgUrl,
                        height: 110.0,
                        width: 80.0,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 5.0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                model.title,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                model.message,
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                              Text(
                                model.time,
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Text(
                          model.price,
                          style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Color.fromARGB(255, 240, 240, 240), width: 1.0),
                    ),
                  ),
                );
              },
              refresh: (context) {
                Future.delayed(Duration(seconds: 3), () {
                  EasyList.of(context).stopRefresh();
                });
              },
              load: (context) {
                Future.delayed(Duration(seconds: 6), () {
                  EasyList.of(context).stopLoadNoMore();
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ItemModel {
  String type;
  String title;
  String imgUrl;
  String time;
  String price;
  String message;

  ItemModel({
    Key key,
    this.type,
    this.title,
    this.imgUrl,
    this.time,
    this.message,
    this.price,
  });
}
