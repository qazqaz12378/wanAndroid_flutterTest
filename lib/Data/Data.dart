import 'dart:io';

import 'package:path_provider/path_provider.dart';
class  Data {
  static Data instance;
  static Data getInstance(){
    if(instance == null) instance = Data();
    return instance;
  }
  Future GetCookieJarPath() async{
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path+'/.cookies/';
   // var cookieJar = PersistCookieJar(dir:appDocPath +'/.cookies/');
    return appDocPath;
  }
}