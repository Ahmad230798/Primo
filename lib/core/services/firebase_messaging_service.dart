import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:primo/core/routing/app_routes.dart';

class FirebaseCloudMessagingService {
  static final FirebaseCloudMessagingService _instance =
      FirebaseCloudMessagingService._internal();
  factory FirebaseCloudMessagingService() => _instance;
  FirebaseCloudMessagingService._internal();

  String? _cachedToken;

  Future<void> init() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }

      final messaging = FirebaseMessaging.instance;

      // Request permission
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        log('User granted permission for Firebase messaging');

        // Fetch token
        _cachedToken = await messaging.getToken();
        log('FCM Device Token: $_cachedToken');

        // Listen for token refresh
        messaging.onTokenRefresh.listen((newToken) {
          _cachedToken = newToken;
          log('FCM Device Token Refreshed: $_cachedToken');
        });

        // Listen for foreground notifications
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          log('Foreground FCM Message Received: ${message.notification?.title}');
          final notification = message.notification;
          if (notification != null) {
            final context = AppRoutes.navigatorKey.currentContext;
            if (context != null && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (notification.title != null)
                        Text(
                          notification.title!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      if (notification.body != null)
                        Text(
                          notification.body!,
                          style: const TextStyle(color: Colors.white),
                        ),
                    ],
                  ),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 4),
                  action: SnackBarAction(
                    label: 'حسناً',
                    textColor: Colors.white,
                    onPressed: () {},
                  ),
                ),
              );
            }
          }
        });
      } else {
        log('User declined or has not accepted permission for Firebase messaging');
      }
    } catch (e) {
      log('Error initializing FirebaseCloudMessagingService: $e');
    }
  }

  Future<String?> getDeviceToken() async {
    if (_cachedToken != null) return _cachedToken;
    try {
      if (Firebase.apps.isNotEmpty) {
        _cachedToken = await FirebaseMessaging.instance.getToken();
        return _cachedToken;
      }
    } catch (e) {
      log('Error getting FCM device token: $e');
    }
    return null;
  }
}
