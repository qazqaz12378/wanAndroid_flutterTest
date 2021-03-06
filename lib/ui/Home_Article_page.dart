import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/bezier_hour_glass_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroid_fluttertest/entity/common_entity.dart';
import 'package:wanandroid_fluttertest/tool/ToastUtil.dart';
import 'package:wanandroid_fluttertest/ui/Login_page.dart';
import '../service/HttpUtil.dart';
import '../Data/HttpData.dart';
import '../entity/ArticleEntity.dart' as Article;
import '../tool/MainTool.dart';

class Home_Article_page extends StatefulWidget {
  @override
  _Home_Article_pageState createState() => _Home_Article_pageState();
}

class _Home_Article_pageState extends State<Home_Article_page>
    with AutomaticKeepAliveClientMixin {
  int _page = 0;
  List<Article.Datas> articleDatas = List();
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getHttpData();
  }

  void getHttpData() async {
    try {
      var articleResponse =
          await HttpUtil.getInstance().get(HttpApiData.HOME + '$_page/json');
      Map articleMap = json.decode(articleResponse.toString());
      var articleModel = Article.ArticleEntity.fromJson(articleMap);
      setState(() {
        articleDatas = articleModel.data.datas;
        //print(articleDatas[1].title);
      });
    } catch (e) {
      print(e);
    }
  }

  void getNextPageData() async {
    var response =
        await HttpUtil.getInstance().get(HttpApiData.HOME + '$_page/json');
    Map _map = json.decode(response.toString());
    var articleEntity = Article.ArticleEntity.fromJson(_map);
    setState(() {
      articleDatas.addAll(articleEntity.data.datas);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('首页'),
      ),
      body: Container(
        color: Colors.white,
        child: EasyRefresh.custom(
          emptyWidget: articleDatas.length == 0
              ? Container(
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(),
                        flex: 2,
                      ),
                      SizedBox(
                        width: 100.0,
                        height: 100.0,
                        child: Image.asset('images/nodata.png'),
                      ),
                      Text(
                        '没有数据',
                        style:
                            TextStyle(fontSize: 16.0, color: Colors.grey[400]),
                      ),
                      Expanded(
                        child: SizedBox(),
                        flex: 3,
                      ),
                    ],
                  ),
                )
              : null,
          firstRefresh: true,
          header: BezierHourGlassHeader(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 1), () {
              setState(() {
                _page = 0;
              });
              getHttpData();
            });
          },
          onLoad: () async {
            await Future.delayed(Duration(seconds: 1), () {
              setState(() {
                _page++;
              });
              getNextPageData();
            });
          },
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index < articleDatas.length) {
                    return getRow(index);
                  }
                  return null;
                },
                childCount: articleDatas.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getRow(int i) {
    return GestureDetector(
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: ListTile(
            leading: IconButton(
              iconSize: 20.0,
              icon: articleDatas[i].collect
                  ? Icon(
                      Icons.favorite,
                      color: Theme.of(context).primaryColor,
                    )
                  : Icon(Icons.favorite_border),
              tooltip: '收藏',
              onPressed: () {
                if (articleDatas[i].collect) {
                  cancelCollect(articleDatas[i].id);
                } else {
                  addCollect(articleDatas[i].id);
                }
              },
            ),
            title: Text(
              MainTool.getInstance()
                  .GetHtmlStringToFlutterString(articleDatas[i].title),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Row(
                children: <Widget>[
                  // Container(
                  //   padding: EdgeInsets.symmetric(horizontal: 6),
                  //   decoration: BoxDecoration(
                  //     border: Border.all(
                  //       color: Theme.of(context).primaryColor,
                  //       width: 1.0,
                  //     ),
                  //     borderRadius: BorderRadius.circular((20.0)), // 圆角度
                  //   ),
                  //   child: Text(
                  //     articleDatas[i].superChapterName,
                  //     style: TextStyle(color: Theme.of(context).primaryColor),
                  //   ),
                  // ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: articleDatas[i].author.isNotEmpty
                        ? Text("作者: " + articleDatas[i].author)
                        : Text("分享人: " + articleDatas[i].shareUser),
                  ),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      "时间: " + articleDatas[i].niceDate,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
                ],
              ),
            ),
            // trailing: Icon(Icons.chevron_right),
          )),
      onTap: () {
        if (0 == 1) return;
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ArticleDetail(
        //         title: articleDatas[i].title, url: articleDatas[i].link),
        //   ),
        // );
      },
    );
  }

  Future addCollect(int id) async {
    var collectResponse =
        await HttpUtil().post(HttpApiData.COLLECT + '$id/json');
    Map map = json.decode(collectResponse.toString());
    var entity = CommonEntity.fromJson(map);
    if (entity.errorCode == -1001) {
      YToast.show(context: context, msg: entity.errorMsg);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      YToast.show(context: context, msg: "收藏成功");
      getHttpData();
    }
  }

  Future cancelCollect(int id) async {
    var collectResponse =
        await HttpUtil().post(HttpApiData.UN_COLLECT_ORIGIN_ID + '$id/json');
    Map map = json.decode(collectResponse.toString());
    var entity = CommonEntity.fromJson(map);
    if (entity.errorCode == -1001) {
      YToast.show(context: context, msg: entity.errorMsg);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      YToast.show(context: context, msg: "取消成功");
      getHttpData();
    }
  }
}
