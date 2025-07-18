import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc/data/services/auth_service.dart';
import 'package:tcc/data/services/medicine_service.dart';
import 'package:tcc/data/services/notification_service.dart';
import 'package:tcc/data/services/prescription_service.dart';
import 'package:tcc/ui/core/navigationBar.dart';
import 'package:tcc/ui/medicine/view_models/get_all_medicine_view_model.dart';
import 'package:tcc/ui/prescription/view_models/get_all_prescription_view_model.dart';
import 'package:tcc/ui/user/view_models/login_user_view_model.dart';
import 'package:tcc/ui/user/view_models/register_user_view_model.dart';
import 'package:tcc/ui/user/widgets/forgot_password_screen.dart';
import 'package:tcc/ui/user/widgets/login_screen.dart';
import 'package:tcc/ui/user/widgets/register_screen.dart';
import 'package:tcc/utils/navigator_service.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  NotificationService.initializeNotification();
  FirebaseMessaging.onBackgroundMessage(
    NotificationService.firebaseMessagingBackgroundHandler,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(),
        ),
        ChangeNotifierProvider<GetAllPrescriptionViewModel>(
          create: (context) => GetAllPrescriptionViewModel(
            PrescriptionService(
              context.read<AuthService>(),
            ),
          ),
        ),
        ChangeNotifierProvider<GetAllMedicineViewModel>(
          create: (context) => GetAllMedicineViewModel(
            MedicineService(
              context.read<AuthService>(),
            ),
          ),
        ),
        ChangeNotifierProvider<LoginUserViewModel>(
          create: (context) => LoginUserViewModel(
            context.read<AuthService>(),
          ),
        ),
        ChangeNotifierProvider<RegisterUserViewModel>(
          create: (context) => RegisterUserViewModel(
            context.read<AuthService>(),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigatorService.navigatorKey,
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => NavigationComponent(),
        '/register': (context) => RegisterScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(backgroundColor: Colors.white),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue,
          secondary: Colors.blueAccent,
          onPrimary: Colors.white,
        ),
      ),
      home: NavigationComponent(),
    );
  }
}
