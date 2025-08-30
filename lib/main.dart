import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tcc/data/services/auth_service.dart';
import 'package:tcc/data/services/medicine_service.dart';
import 'package:tcc/data/services/notification_service.dart';
import 'package:tcc/data/services/prescription_service.dart';
import 'package:tcc/data/services/recommendation_service.dart';
import 'package:tcc/data/services/user_service.dart';
import 'package:tcc/ui/core/navigationBar.dart';
import 'package:tcc/ui/medicine/view_models/get_all_medicine_view_model.dart';
import 'package:tcc/ui/notification/view_models/get_all_upcoming_notifications_view_model.dart';
import 'package:tcc/ui/prescription/view_models/add_prescription_view_model.dart';
import 'package:tcc/ui/prescription/view_models/get_all_prescription_view_model.dart';
import 'package:tcc/ui/prescription/view_models/get_by_id_view_model.dart';
import 'package:tcc/ui/prescription/view_models/update_status_notification_view_model.dart';
import 'package:tcc/ui/recommendationsAi/view_model/generate_ai_view_model.dart';
import 'package:tcc/ui/user/view_models/create_health_view_model.dart';
import 'package:tcc/ui/user/view_models/get_user_disease_view_model.dart';
import 'package:tcc/ui/user/view_models/get_user_view_model.dart';
import 'package:tcc/ui/user/view_models/login_user_view_model.dart';
import 'package:tcc/ui/user/view_models/register_user_view_model.dart';
import 'package:tcc/ui/user/widgets/forgot_password_screen.dart';
import 'package:tcc/ui/user/widgets/login_screen.dart';
import 'package:tcc/ui/user/widgets/register_screen.dart';
import 'package:tcc/utils/navigator_service.dart';

import 'data/services/health_service.dart';
import 'data/services/prescription_notifications_service.dart';
import 'firebase_options.dart';

Future<void> _initFirebaseAndNotifications() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (Platform.isAndroid) {
    await NotificationService.initializeNotification();
    FirebaseMessaging.onBackgroundMessage(
      NotificationService.firebaseMessagingBackgroundHandler,
    );
  }
}

Future<bool> _hasToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token') != null;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initFirebaseAndNotifications();
  final isLoggedIn = await _hasToken();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider<GetAllPrescriptionViewModel>(
          create: (context) => GetAllPrescriptionViewModel(
            PrescriptionService(context.read<AuthService>()),
          ),
        ),
        ChangeNotifierProvider<GetUserViewModel>(
          create: (context) => GetUserViewModel(UserService(context.read<AuthService>())),
        ),
        ChangeNotifierProvider<GenerateAiViewModel>(
          create: (context) => GenerateAiViewModel(
            RecommendationService(context.read<AuthService>()),
          ),
        ),
        ChangeNotifierProvider<GetAllUpcomingNotificationsViewModel>(
          create: (context) => GetAllUpcomingNotificationsViewModel(
            PrescriptionNotificationService(context.read<AuthService>()),
          ),
        ),
        ChangeNotifierProvider<GetAllMedicineViewModel>(
          create: (context) => GetAllMedicineViewModel(
            MedicineService(context.read<AuthService>()),
          ),
        ),
        ChangeNotifierProvider<GetUserDiseaseViewModel>(
          create: (context) => GetUserDiseaseViewModel(
            HealthService(context.read<AuthService>()),
          ),
        ),
        ChangeNotifierProvider<LoginUserViewModel>(
          create: (context) => LoginUserViewModel(context.read<AuthService>()),
        ),
        ChangeNotifierProvider<RegisterUserViewModel>(
          create: (context) => RegisterUserViewModel(context.read<AuthService>()),
        ),
        ChangeNotifierProvider<AddPrescriptionViewModel>(
          create: (context) => AddPrescriptionViewModel(
            PrescriptionService(context.read<AuthService>()),
          ),
        ),
        ChangeNotifierProvider<GetByIdViewModel>(
          create: (context) => GetByIdViewModel(
            PrescriptionService(context.read<AuthService>()),
          ),
        ),
        ChangeNotifierProvider<CreateHealthViewModel>(
          create: (context) => CreateHealthViewModel(
            HealthService(context.read<AuthService>()),
          ),
        ),
        ChangeNotifierProvider<UpdateStatusNotificationViewModel>(
          create: (context) => UpdateStatusNotificationViewModel(
            PrescriptionService(context.read<AuthService>()),
            context.read<GetByIdViewModel>(),
          ),
        ),
      ],
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigatorService.navigatorKey,
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const NavigationComponent(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue,
          secondary: Colors.blueAccent,
          onPrimary: Colors.white,
        ),
        dividerTheme: const DividerThemeData(
          color: Colors.grey,
          thickness: 0.5,
          space: 30,
          indent: 40,
          endIndent: 0,
        ),
      ),
      home: isLoggedIn ? const NavigationComponent() : const LoginPage(),
      // Se preferir rotas nomeadas:
      // initialRoute: isLoggedIn ? '/home' : '/login',
    );
  }
}
