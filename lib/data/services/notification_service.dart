import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await _initializeLocalNotification();
    await _showFlutterNotification(message);
  }

  // Initializes Firebase Messaging and Local Notifications
static Future<void> initializeNotification() async {
  // Request permissions (required on iOS, optional on Android)
  await _firebaseMessaging.requestPermission();

  // Called when message is received while app is in foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    await _showFlutterNotification(message);
  });

  // Called when app is brought to foreground from background by tapping a notification
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("App opened from background notification: ${message.data}");
  });

  // Get and print FCM token (for sending targeted messages)
  await _getFcmToken();

  // Initialize the local notification plugin
  await _initializeLocalNotification();

  // Check if app was launched by tapping on a notification
  await _getInitialNotification();
}

/// Fetches and prints FCM token (optional)
static Future<void> _getFcmToken() async {
  String? token = await _firebaseMessaging.getToken();
  print('FCM Token: $token');
  // Use this token to send messages to this device
}

  static Future<void> _showFlutterNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    Map<String, dynamic>? data = message.data;

    String title = notification?.title ?? data?['title'] ?? 'No Title';
    String body = notification?.body ?? data?['body'] ?? 'No Body';

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'CHANEL_ID',
      'CHANEL_NAME',
      channelDescription: 'Notification channel for basic tests',
      priority: Priority.high,
      importance: Importance.high,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  static Future<void> _initializeLocalNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        print('User tapped notification: ${response.payload}');
      },
    );
  }

  /// Handles notification tap when app is terminated
static Future<void> _getInitialNotification() async {
  RemoteMessage? message =
      await FirebaseMessaging.instance.getInitialMessage();

  if (message != null) {
    print(
      "App launched from terminated state via notification: ${message.data}",
    );
  }
}
}
