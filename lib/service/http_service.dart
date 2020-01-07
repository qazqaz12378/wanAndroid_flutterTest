import 'dart:async';
import 'package:dio/dio.dart';

Future request(url,{formData}) async{
  try{
    Response response;
    Dio dio = Dio();
    response = await dio.post(url,data:formData);
    if(response.statusCode == 200){
      return response;
    }else{
      throw Exception('异常:'+response.statusCode.toString());
    }

  }catch(e){
    return print('error:::${e}');
  }
}