import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_commerce_refactor/models/AppNotification.dart';
import 'package:e_commerce_refactor/providers/UserProvider.dart';
import 'package:e_commerce_refactor/services/ApiClient.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NotificationProvider extends ChangeNotifier{
  final List<AppNotification> _notifications = [];

  bool _isConnected = false;
  int _unreadCount = 0;

  StreamSubscription? _subscription;

  List<AppNotification> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isConnected => _isConnected;

  late XFile image;

Future<void> initSSEConnection(UserProvider userProvider) async {
    // 1. Strict Guard: Don't start if already active or currently trying
    if (_isConnected) return;

    notifyListeners();

    try {
      final response = await Apiclient.dio.get(
        '/notifications/stream',
        options: Options(
          responseType: ResponseType.stream,
          receiveTimeout: Duration.zero,
          sendTimeout: Duration.zero,
          headers: {
            "Accept": "text/event-stream",
            "Cache-Control": "no-cache"
          }
        )
      );

      // We only reach here if the Status is 200
      _isConnected = true;
      notifyListeners();

      // Cancel any old subscription just in case
      await _subscription?.cancel();

      _subscription = response.data.stream
          .cast<List<int>>()
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
        (line) async{
          debugPrint("Raw Line : $line");

            if(line.contains("UnAuthorized")){

              debugPrint("SSE UnAuthorized Detected....\nAttempting Manual Refresh....");

              _subscription?.cancel();
              _isConnected = false;
              notifyListeners();

              final success = await Apiclient.forceManualRefresh();

              if(success){
                debugPrint("Refresh Successful.\nAttempting to Connect Back to SSE Connection....");

                await userProvider.refreshUsername();

                Future.delayed(const Duration(seconds: 2), () => initSSEConnection(userProvider));
              }
              else{
                debugPrint("Refresh Failed.....\nUser must Login Again.....");
              }
            }


            if (line.startsWith("data: ")) {
              final String rawData = line.substring(6).trim();
              if (rawData.isNotEmpty && rawData != "ping") {
                _processNewNotification(rawData);
              }
            }

            if(line.startsWith("id: ")){
              final itemId = line.substring(4).trim();
              userProvider.uploadImage(itemId, image);
            }
        },
        onError: (error) {
          debugPrint("SSE Stream Error: $error");
          _handleDisconnect(userProvider);
        },
        onDone: () async{
          debugPrint("SSE Stream closed by server.");
          _handleDisconnect(userProvider);
        },
        cancelOnError: true,
      );
    } catch (e) {
      debugPrint("Initial SSE Connection Error: $e");
      _handleDisconnect(userProvider);
    }
  }

  void _handleDisconnect(UserProvider userProvider) {
    _isConnected = false;
    _subscription?.cancel();
    notifyListeners();

    debugPrint("Disconnected. Retrying in 5 seconds...");
    
    // Add a check: Only reconnect if the user is still authenticated
    // if (!userIsLoggedIn) return; 

    Future.delayed(const Duration(seconds: 5), () => initSSEConnection(userProvider));
  }

  void _processNewNotification(String rawData){
    final Map<String, dynamic> data = jsonDecode(rawData);

    final newNotification = AppNotification.fromJson(data);

    _notifications.insert(0, newNotification);
    _unreadCount++;
    notifyListeners();
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