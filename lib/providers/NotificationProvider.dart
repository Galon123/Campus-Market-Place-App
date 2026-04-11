import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_commerce_refactor/models/AppNotification.dart';
import 'package:e_commerce_refactor/services/ApiClient.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier{
  final List<AppNotification> _notifications = [];

  bool _isConnected = false;
  bool _isConnecting = false;
  int _unreadCount = 0;

  StreamSubscription? _subscription;

  List<AppNotification> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isConnected => _isConnected;

Future<void> initSSEConnection() async {
    // 1. Strict Guard: Don't start if already active or currently trying
    if (_isConnected || _isConnecting) return;

    _isConnecting = true;
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
      _isConnecting = false;
      notifyListeners();

      // Cancel any old subscription just in case
      await _subscription?.cancel();

      _subscription = response.data.stream
          .cast<List<int>>()
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
        (line) {
          if (line.startsWith("data: ")) {
            final String rawData = line.substring(6).trim();
            // 2. Add 'ping' check here to ignore server heartbeats
            if (rawData.isNotEmpty && rawData != "ping" && rawData != ":") {
              _processNewNotification(rawData);
            }
          }
        },
        onError: (error) {
          debugPrint("SSE Stream Error: $error");
          _handleDisconnect();
        },
        onDone: () {
          debugPrint("SSE Stream closed by server.");
          _handleDisconnect();
        },
        cancelOnError: true,
      );
    } catch (e) {
      debugPrint("Initial SSE Connection Error: $e");
      _handleDisconnect();
    }
  }

  // 3. Centralized disconnection logic to prevent "Parallel Loops"
  void _handleDisconnect() {
    _isConnected = false;
    _isConnecting = false;
    _subscription?.cancel();
    notifyListeners();

    debugPrint("Disconnected. Retrying in 5 seconds...");
    
    // Add a check: Only reconnect if the user is still authenticated
    // if (!userIsLoggedIn) return; 

    Future.delayed(const Duration(seconds: 5), () => initSSEConnection());
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