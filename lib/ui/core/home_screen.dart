import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:tcc/ui/home/widgets/section_upcoming_notifications.dart';
import 'package:tcc/ui/recommendationsAi/widgets/section_recommendations_component.dart';

import '../user/widgets/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final now = DateTime.now();

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
              icon: const Icon(Icons.search_rounded),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              icon: const Icon(Icons.account_circle_rounded),
            ),
          ],
        ),
        body: ListView(

          children: [
            Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionRecommendationsComponent(),
                SectionUpcomingNotifications(),
                // SectionPrescriptions(),
              ],
            ),
          ]
        ),
      ),
    );
  }
}
