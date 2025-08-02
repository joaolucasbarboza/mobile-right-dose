import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // só dispara on background para Android
    if (!Platform.isAndroid) return;
    await _initializeLocalNotification();
    await _showFlutterNotification(message);
  }

  static Future<void> initializeNotification() async {
    // no iOS, pular tudo
    if (Platform.isIOS) return;

    // Request permissions (Android ignora sem problema)
    await _firebaseMessaging.requestPermission();

    // Mensagem em foreground
    FirebaseMessaging.onMessage.listen((message) async {
      await _showFlutterNotification(message);
    });

    // App aberto por notificação
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint("App opened from notification: ${message.data}");
    });

    // Token para enviar mensagens direcionadas
    await _getFcmToken();

    // Inicializa plugin local
    await _initializeLocalNotification();

    // Checa se veio via notificação quando app estava morto
    await _getInitialNotification();
  }

  static Future<void> _getFcmToken() async {
    String? token = await _firebaseMessaging.getToken();
    debugPrint('FCM Token: $token');
  }

  static Future<void> _showFlutterNotification(RemoteMessage message) async {
    // só exibe no Android
    if (!Platform.isAndroid) return;

    final notif = message.notification;
    final data = message.data;
    final title = notif?.title ?? data['title'] ?? 'No Title';
    final body = notif?.body ?? data['body'] ?? 'No Body';

    final androidDetails = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      channelDescription: 'Canal de notificações básicas',
      importance: Importance.high,
      priority: Priority.high,
    );

    final details = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(0, title, body, details);
  }

  static Future<void> _initializeLocalNotification() async {
    // só precisa inicializar no Android
    if (!Platform.isAndroid) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint('Notification tapped: ${response.payload}');
      },
    );
  }

  static Future<void> _getInitialNotification() async {
    // só faz sentido no Android aqui
    if (!Platform.isAndroid) return;

    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      debugPrint(
          "Launched from terminated state by notification: ${message.data}");
    }
  }
}