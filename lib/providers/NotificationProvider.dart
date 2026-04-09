import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_commerce_refactor/models/AppNotification.dart';
import 'package:e_commerce_refactor/services/ApiClient.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier{
  final List<AppNotification> _notifications = [];

  bool _isConnected = false;
  int _unreadCount = 0;


  List<AppNotification> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isConnected => _isConnected;

  Future<void> initSSEConnection() async {

    if(isConnected) return;

    try{ 

      final response = await Apiclient.dio.get(
        '/notifications/stream',
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            "Accept" : "text/event-stream",
            "Cache-Control" : "no-cache"
          }
        )
      );

      _isConnected = true;
      notifyListeners();


      response.data.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(
          (line) {
            if(line.startsWith("data: ")){
              final String rawData = line.substring(6).trim();
              if(rawData.isNotEmpty && rawData != "ping"){
                _processNewNotification(rawData);
              }
            }
          },
          onError: (error) => _reconnect(),
          cancelOnError: true
        );
    } catch(e) {
      debugPrint("SSE Connection Error : $e");
      _reconnect();
    }
  }

  void _processNewNotification(String rawData){
    final Map<String, dynamic> data = jsonDecode(rawData);

    final newNotification = AppNotification.fromJson(data);

    _notifications.insert(0, newNotification);
    _unreadCount++;
    notifyListeners();
  }

  void _reconnect(){

    _isConnected = false;
    notifyListeners();

    Future.delayed(const Duration(seconds: 5), () => initSSEConnection());
  }

  void markAsRead() {
    _unreadCount =0;
    notifyListeners();
  }

  void clearAll() {
    _notifications.clear();
    _unreadCount =0;
    notifyListeners();
  }

}