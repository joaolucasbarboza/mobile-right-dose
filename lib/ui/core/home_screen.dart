import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc/data/services/auth_service.dart';
import 'package:tcc/ui/home/widgets/section_upcoming_notifications.dart';
import 'package:tcc/ui/recommendationsAi/widgets/section_recommendations_component.dart';
import 'package:tcc/ui/user/widgets/profile_screen.dart';
import 'package:tcc/ui/notification/view_models/get_all_upcoming_notifications_view_model.dart';
import 'package:tcc/data/services/recommendation_service.dart';
import 'package:tcc/ui/recommendationsAi/view_model/generate_ai_view_model.dart';

import '../../data/services/prescription_notifications_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final now = DateTime.now();

  late final GenerateAiViewModel _recVm;
  late final GetAllUpcomingNotificationsViewModel _notifVm;
  late final AuthService _auth;



  @override
  void initState() {
    super.initState();
    _auth = context.read<AuthService>();

    _recVm = GenerateAiViewModel(RecommendationService(_auth));
    _notifVm = GetAllUpcomingNotificationsViewModel(PrescriptionNotificationService(_auth));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _notifVm.fetchUpcomingNotifications();
    });
  }

  @override
  void dispose() {
    _recVm.dispose();
    _notifVm.dispose();
    super.dispose();
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
              Text("Olá João",
                style: TextStyle(fontSize: 18, color: colorScheme.onSurfaceVariant),
              ),
              Text(
                formatDate(now, [dd, ' ', M, ' ', yyyy], locale: PortugueseDateLocale()),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded)),
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
              },
              icon: const Icon(Icons.account_circle_rounded),
            ),
          ],
        ),

        body: RefreshIndicator(
          onRefresh: () async {
            await _notifVm.fetchUpcomingNotifications();
            // await _recVm.generateRecommendation();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionRecommendationsComponent(viewModel: _recVm),
                    const SizedBox(height: 8),
                    SectionUpcomingNotifications(viewModel: _notifVm),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}