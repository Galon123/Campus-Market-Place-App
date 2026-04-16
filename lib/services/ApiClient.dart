import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

const BASE_URL = "http://127.0.0.1:8000";

class Apiclient {

  static String get baseUrl => BASE_URL;

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

  static Future<bool> forceManualRefresh() async{

    try{

      final response = await dio.post("/refresh");
      return response.statusCode == 200;

    } catch (e){
      debugPrint("Error in Manual Refresh....");
      return false;
    }

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
  void onResponse(Response response, ResponseInterceptorHandler handler){

    if(response.data is Map && response.data['error_code'] == "UnAuthorized"){
      debugPrint("Interceptive UnAuthorized found. Redirecting to error Handler.....");

      return handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: Response(
            requestOptions: response.requestOptions,
            statusCode: 401,
            data: response.data
          ),
          type: DioExceptionType.badResponse,
        )
      );
    }

    return handler.next(response);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async{

    if (err.requestOptions.path.contains('/refresh') || 
      err.requestOptions.path.contains('/login')) {
    return handler.next(err);
  }

    if(err.response?.statusCode == 401){
      debugPrint("Access Token Expired.Attempting Refresh....");
      
      try{

        final refreshRes = await Apiclient.dio.post('/refresh');

        if(refreshRes.statusCode == 200){
          debugPrint("Refresh Successful. Retrying Original Request.....");

          final response = await _retry(err.requestOptions);
          return handler.resolve(response);
        }
      } catch (e) {
        debugPrint("Refresh Token Expired. Logging out....");
      }
    }

    return handler.next(err);
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