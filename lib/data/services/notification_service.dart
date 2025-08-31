// NotificationService.dart
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tcc/utils/navigator_service.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    if (!Platform.isAndroid) return;
    await _initializeLocalNotification();
    await _showFlutterNotification(message);
  }

  static Future<void> initializeNotification() async {
    if (Platform.isIOS) return;

    // permissões
    await _firebaseMessaging.requestPermission();

    // Mensagem recebida em foreground
    FirebaseMessaging.onMessage.listen((message) async {
      await _showFlutterNotification(message);
    });

    // Usuário clicou na notificação
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNotificationTap(_extractPayloadString(message));
    });

    // Token para debug/envio direcionado
    await _getFcmToken();

    // Inicialização local
    await _initializeLocalNotification();

    // Mensagem que abriu o app "morto"
    await _getInitialNotification();
  }

  static Future<void> _getFcmToken() async {
    final token = await _firebaseMessaging.getToken();
    debugPrint('FCM Token: $token');
  }

  static Future<void> _showFlutterNotification(RemoteMessage message) async {
    if (!Platform.isAndroid) return;

    final notif = message.notification;
    final data = message.data;
    final title = notif?.title ?? data['title'] ?? 'Lembrete de medicação';
    final body = notif?.body ?? data['body'] ?? 'Você tem um lembrete.';

    // log para debug
    debugPrint("🔔 Notificação recebida: $data");

    const androidDetails = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      channelDescription: 'Canal de notificações básicas',
      importance: Importance.high,
      priority: Priority.high,
    );

    final details = const NotificationDetails(android: androidDetails);

    // payload sempre vai no clique da notificação
    final payloadString = _extractPayloadString(message);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      details,
      payload: payloadString,
    );
  }

  static String _extractPayloadString(RemoteMessage message) {
    // Se já vem pronto
    if (message.data['payload'] != null) {
      return message.data['payload']!;
    }
    // fallback: empacota os campos como JSON
    return jsonEncode(message.data);
  }

  static Future<void> _initializeLocalNotification() async {
    if (!Platform.isAndroid) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        _handleNotificationTap(response.payload);
      },
    );
  }

  static Future<void> _getInitialNotification() async {
    if (!Platform.isAndroid) return;
    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      debugPrint("📦 Inicial por notificação: ${message.data}");
      _handleNotificationTap(_extractPayloadString(message));
    }
  }

  static void _handleNotificationTap(String? payload) {
    if (payload == null) return;
    final notificationId = _parseNotificationId(payload);
    if (notificationId == null) {
      debugPrint("⚠️ notificationId não encontrado no payload: $payload");
      return;
    }

    final ctx = NavigatorService.navigatorKey.currentContext;
    if (ctx == null) return;

    Navigator.of(ctx).pushNamed(
      '/notification-sheet',
      arguments: notificationId,
    );
  }

  static String? _parseNotificationId(String payload) {
    try {
      final map = jsonDecode(payload);
      if (map is Map && map['notificationId'] != null) {
        return map['notificationId'].toString();
      }
    } catch (_) {
      final parts = payload.split(RegExp(r'[;&]'));
      for (final p in parts) {
        final kv = p.split('=');
        if (kv.length == 2 && kv[0].trim() == 'notificationId') {
          return kv[1].trim();
        }
      }
    }
    return null;
  }
}