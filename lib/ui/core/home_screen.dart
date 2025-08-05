import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcc/ui/home/widgets/section_notifications.dart';

import '../user/widgets/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final now = DateTime.now();

  @override
  void initState() {
    super.initState();
    verifyUser().then((value) {
      if (!value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 12,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Olá João",
                style: TextStyle(
                  fontSize: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                formatDate(
                  now,
                  [dd, ' ', M, ' ', yyyy],
                  locale: PortugueseDateLocale(),
                ),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search_rounded),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications_none_rounded),
            ),
            IconButton(
              onPressed: () {
                logoutUser();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              icon: Icon(Icons.account_circle_rounded),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SectionNotifications(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logoutUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove("token");
  }

  Future<bool> verifyUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString("token");

    if (token == null) {
      return false;
    } else {
      return true;
    }
  }
}
