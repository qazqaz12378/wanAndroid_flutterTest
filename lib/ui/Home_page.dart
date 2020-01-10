import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
class Home_Page extends StatefulWidget {
  @override
  _Home_PageState createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.blueAccent,
        items: <Widget>[
          Icon(Icons.add,size:30.0),
          Icon(Icons.list,size:30.0),
          Icon(Icons.compare_arrows,size: 30.0),
        ],
        onTap: (index){

        },
      ),
      body: Container(color: Colors.blueAccent,),
    );
  }
}