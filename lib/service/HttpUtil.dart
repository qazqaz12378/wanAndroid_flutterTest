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
Future post(url,{data}) async{
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
get(url,{data}) async{
  Response response;
  try {
    response = await dio.get(url,queryParameters:data);
  }on DioError catch (e) {
    formatError(e);
  }
  return response;
}

void formatError(DioError e){
  if(e.type == DioErrorType.CONNECT_TIMEOUT){
    print('连接超时');
  }else if(e.type == DioErrorType.SEND_TIMEOUT){
    print('请求超时');
  }else if(e.type == DioErrorType.RECEIVE_TIMEOUT){
    print('响应超时');
  }else if(e.type == DioErrorType.RESPONSE){
    print('出现异常');
  }else if(e.type == DioErrorType.CANCEL){
    print('请求取消');
  }else{
    print('未知错误');
  }
}
}