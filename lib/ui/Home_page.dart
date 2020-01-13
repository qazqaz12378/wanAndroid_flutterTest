import 'package:flutter/material.dart';
import '../bottomNavigationBarBase/curved_navigation_bar.dart';
import 'Home_Article_page.dart';
class Home_Page extends StatefulWidget {
  @override
  _Home_PageState createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page>
    with SingleTickerProviderStateMixin {
  int _page = 0;
  GlobalKey _bottomNavihationKey = GlobalKey();
  TabController tabController;
  List colors = [Colors.blue, Colors.pink, Colors.orange];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(vsync: this, length: 3)
      ..addListener(() {
        setState(() {
          _page = tabController.index;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(    
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavihationKey,
        index: _page,
        
       // backgroundColor: Colors.white,//colors[_page],
       // color: Colors.redAccent,
        //height: 50.0,
        shader: 6.0,
        backgroundColor: Colors.transparent,
        items: <Widget>[
          Icon(Icons.home, size: 25.0),
          Icon(Icons.work, size: 25.0),
          Icon(Icons.fiber_new, size: 25.0)
        ],

        animationDuration: Duration(milliseconds: 500),
        onTap: (index) {
          setState(() {
            _page = index;
          });
          tabController.animateTo(index,
              duration: Duration(milliseconds: 300), curve: Curves.ease);
        },
      ),
      body: TabBarView(
        controller: tabController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Home_Article_page(),
          Container(
            color: colors[1],
          ),
          Container(
            color: colors[2],
          )
        ],
      ),
    );
  }
}
