
import 'package:html_unescape/html_unescape.dart';

class  MainTool {
  static MainTool instance;
   var unescape = new HtmlUnescape();
  static MainTool getInstance(){
    if(instance == null) instance = MainTool();
    return instance;
  }

  GetHtmlStringToFlutterString(String str){
    return unescape.convert(str);
  }
}