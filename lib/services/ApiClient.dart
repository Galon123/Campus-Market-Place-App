import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

const BASE_URL = "http://0.0.0.0:8000";

class Apiclient {

  static final Dio dio = Dio(BaseOptions(
    baseUrl: BASE_URL,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3)
  ));
  static late PersistCookieJar cookieJar;

  static Future<void> setup() async{

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    cookieJar = PersistCookieJar(
      storage: FileStorage("$appDocPath/.cookies/")
    );

    dio.interceptors.add(CookieCleaner());

    //CookieManager
    dio.interceptors.add(CookieManager(cookieJar));

    //Logging Requests and Responses
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  static Future<bool> hasValidSession() async{
    var cookies = await cookieJar.loadForRequest(Uri.parse(dio.options.baseUrl));
    return cookies.isNotEmpty;
  }
}

class CookieCleaner extends Interceptor{
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler){

    final cookies = response.headers['set-cookie'];

    if(cookies != null && cookies.isNotEmpty){
      
      final cleanCookies = cookies.map((cookie) {
        if(cookie.contains("Bearer ")){
          return cookie.replaceFirst("Bearer ", "");
        }
        return cookie;
      }).toList();

      response.headers.set('set-cookie', cleanCookies);
    }

    return handler.next(response);
  }
}