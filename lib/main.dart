import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc/data/services/auth_service.dart';
import 'package:tcc/data/services/medicine_service.dart';
import 'package:tcc/data/services/prescription_service.dart';
import 'package:tcc/ui/core/navigationBar.dart';
import 'package:tcc/ui/medicine/view_models/get_all_medicine_view_model.dart';
import 'package:tcc/ui/prescription/view_models/get_all_prescription_view_model.dart';
import 'package:tcc/ui/user/view_models/login_user_view_model.dart';
import 'package:tcc/ui/user/widgets/login_screen.dart';
import 'package:tcc/utils/navigator_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<GetAllPrescriptionViewModel>(
          create: (context) => GetAllPrescriptionViewModel(
            PrescriptionService(
              AuthService(),
            ),
          ),
        ),
        ChangeNotifierProvider<GetAllMedicineViewModel>(
          create: (context) => GetAllMedicineViewModel(
            MedicineService(AuthService()),
          ),
        ),
        ChangeNotifierProvider<LoginUserViewModel>(
          create: (context) => LoginUserViewModel(AuthService()),
        )
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
