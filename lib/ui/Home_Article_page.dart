import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/bezier_hour_glass_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../service/HttpUtil.dart';
import '../Data/HttpData.dart';
import '../entity/ArticleEntity.dart' as Article;
import '../tool/MainTool.dart';

class Home_Article_page extends StatefulWidget {
  @override
  _Home_Article_pageState createState() => _Home_Article_pageState();
}

class _Home_Article_pageState extends State<Home_Article_page> {
  int _page = 0;
  List<Article.Datas> articleDatas = List();

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
              icon: articleDatas[i].collect
                  ? Icon(
                      Icons.favorite,
                      color: Theme.of(context).primaryColor,
                    )
                  : Icon(Icons.favorite_border),
              tooltip: '收藏',
              onPressed: () {
                if (articleDatas[i].collect) {
                  // cancelCollect(articleDatas[i].id);
                } else {
                  // addCollect(articleDatas[i].id);
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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular((20.0)), // 圆角度
                    ),
                    child: Text(
                      articleDatas[i].superChapterName,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(articleDatas[i].author),
                  ),
                ],
              ),
            ),
            trailing: Icon(Icons.chevron_right),
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
}
