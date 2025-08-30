import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:tcc/data/services/auth_service.dart';
import 'package:tcc/data/services/user_service.dart';
import 'package:tcc/ui/home/widgets/section_upcoming_notifications.dart';
import 'package:tcc/ui/recommendationsAi/widgets/section_recommendations_component.dart';
import 'package:tcc/ui/user/view_models/get_user_view_model.dart';
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
  late final GetUserViewModel _getUserViewModel;
  late final AuthService _auth;

  @override
  void initState() {
    super.initState();
    _auth = context.read<AuthService>();

    _recVm = GenerateAiViewModel(RecommendationService(_auth));
    _notifVm = GetAllUpcomingNotificationsViewModel(PrescriptionNotificationService(_auth));
    _getUserViewModel = GetUserViewModel(UserService(_auth));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getUserViewModel.fetchUser();
      await _notifVm.fetchUpcomingNotifications();
    });
  }

  @override
  void dispose() {
    _recVm.dispose();
    _notifVm.dispose();
    _getUserViewModel.dispose();
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
              Text("Olá, ${_getUserViewModel.user.name}",
                style: TextStyle(fontSize: 18, color: colorScheme.onSurfaceVariant),
              ),
              Text(
                formatDate(now, [dd, ' ', M, ' ', yyyy], locale: PortugueseDateLocale()),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(LucideIcons.search600)),
            IconButton(onPressed: () {}, icon: const Icon(LucideIcons.bellRing600)),
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(user: _getUserViewModel.user,)));
              },
              icon: const Icon(LucideIcons.circleUserRound600),
            ),
          ],
        ),

        body: RefreshIndicator(
          onRefresh: () async {
            await _notifVm.fetchUpcomingNotifications();
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
                    Divider(
                      indent: 0,
                      endIndent: 0,
                      height: 60,
                    ),
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