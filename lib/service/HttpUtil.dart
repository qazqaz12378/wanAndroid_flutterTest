import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import '../Data/HttpData.dart' as api;
import '../Data/Data.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

class HttpUtil{
  static HttpUtil instance;
  Dio dio;
  BaseOptions options;
  CancelToken cancelToken = CancelToken();
  PersistCookieJar cookieJar;
  static HttpUtil getInstance(){
    if(instance == null) instance = HttpUtil();
    return instance;
  }
  HttpUtil(){
    options = BaseOptions(
      baseUrl: api.HttpApiData.BASE_URL,
      connectTimeout: 10000,
      receiveTimeout: 5000,
      headers: {
        'version': '1.0.0'
      },
      contentType: Headers.jsonContentType,
      responseType: ResponseType.plain
    );
    dio = Dio(options);
    
    Data.getInstance().GetCookieJarPath().then((value){
      var cookie = PersistCookieJar(dir: value);
      if(cookie != null){
        cookieJar = cookie;
      }
      dio.interceptors.add(CookieManager(cookieJar));
    });
    
    
  }
Future request(url,{data}) async{
  try{
    Response response;
    response = await dio.post(url,queryParameters: data);
    print('post success---------${response.data}');
    if(response.statusCode == 200){
      return response;
    }else{
      throw Exception('异常:'+response.statusCode.toString());
    }

  }catch(e){
    return print('error:::${e}');
  }
}
}