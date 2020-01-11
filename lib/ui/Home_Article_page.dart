import 'dart:convert';

import 'package:flutter/material.dart';
import '../service/HttpUtil.dart';
import '../Data/HttpData.dart';
import '../entity/ArticleEntity.dart' as Article;
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
    getHttpData();
  }

  void getHttpData() async{
    try {
      var articleResponse = await HttpUtil.getInstance().get(HttpApiData.HOME+ '$_page/json');
      Map articleMap = json.decode(articleResponse.toString());
      var articleModel = Article.ArticleEntity.fromJson(articleMap);
      setState(() {
        articleDatas = articleModel.data.datas;
        print(articleDatas[1].title);
      });
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      child: Center(
        child: Text(articleDatas[1].title),
      )
    );
  }

 
}