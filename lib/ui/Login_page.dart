import 'dart:convert';

import 'package:flutter/material.dart';
import '../service/HttpUtil.dart';
import '../Data/HttpData.dart' as api;
import 'Home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var leftRightPadding = 30.0;
  var topBottomPadding = 4.0;
  var textTips = new TextStyle(fontSize: 16.0, color: Colors.black);
  var hintTips = new TextStyle(fontSize: 15.0, color: Colors.black26);
  var _userNameController = new TextEditingController();

  var _userPassController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                  leftRightPadding, 50.0, leftRightPadding, 10.0),
              child: TextField(
                style: hintTips,
                controller: _userNameController,
                decoration: InputDecoration(hintText: "请输入用户名"),
                obscureText: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  leftRightPadding, 25.0, leftRightPadding, topBottomPadding),
              child: TextFormField(
                style: hintTips,
                controller: _userPassController,
                decoration: InputDecoration(hintText: '密码'),
                obscureText: true,
              ),
            ),
            Container(
              width: 150.0,
              margin: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0.0),
              child: RaisedButton(
                elevation: 10.0,
                child: Text(
                  '登录',
                  style: TextStyle(fontSize: 16.0),
                ),
                onPressed: () {
                  if (_userNameController.text.length != 0 ||
                      _userPassController.text.length != 0) {
                    // SendLogin(_userNameController.text,_userPassController.text);
                    var data = {
                      'username': _userNameController,
                      'password': _userPassController
                    };
                   HttpUtil.getInstance().request(api.HttpApiData.LOGIN, data: data).then((value) {
                      var data = json.decode(value.toString());
                      if (data["errorCode"].toString() != 0.toString()) {
                        ShowDialogInit(context, '提示', data["errorMsg"]);
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => Home_Page()));
                      }
                    });
                  } else {
                    ShowDialogInit(context, "提示", "账号密码不能为空");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void ShowDialogInit(BuildContext context, String title, String text_context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text_context),
        );
      });
}
// void SendLogin(String name,String password) async {
//   try {
//     Response response = await Dio().post(
//         "https://www.wanandroid.com/user/login",
//         data: {"username": name, "password": password});

//   } catch (e) {
//     print(e);
//   }
// }
