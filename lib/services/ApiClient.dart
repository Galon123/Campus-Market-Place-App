import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

const BASE_URL = "http://192.168.1.12:8000";

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

    //AuthInterceptor(For refresh token)
    dio.interceptors.add(AuthInterceptor());

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

class AuthInterceptor extends Interceptor{

  @override
  Future<void> onError(DioException error, ErrorInterceptorHandler handler) async{

    if (error.requestOptions.path.contains('/refresh') || 
      error.requestOptions.path.contains('/login')) {
    return handler.next(error);
  }

    if(error.response?.statusCode == 401){
      debugPrint("Access Token Expired.Attempting Refresh....");
      
      try{

        final refreshRes = await Apiclient.dio.post('/refresh');

        if(refreshRes.statusCode == 200){
          debugPrint("Refresh Successful. Retrying Original Request.....");

          final response = await _retry(error.requestOptions);
          return handler.resolve(response);
        }
      } catch (e) {
        debugPrint("Refresh Token Expired. Logging out....");
      }
    }

    return handler.next(error);
  }

  Future<Response> _retry(RequestOptions requestOptions){

    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers
    );

    return Apiclient.dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options
    );

  }
}