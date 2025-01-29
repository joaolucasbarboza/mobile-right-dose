import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:date_format/date_format.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final now = DateTime.now();
  final List<String> months = [
    "Jan",
    "Fev",
    "Mar",
    "Abr",
    "Mai",
    "Jun",
    "Jul",
    "Ago",
    "Set",
    "Out",
    "Nov",
    "Dez"
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 12, // 12 abas, uma para cada mês
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
              icon: Icon(Iconsax.search_normal_1_copy),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Iconsax.notification_copy),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Iconsax.user_copy),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48), // Ajuste fino da altura
            child: TabBar(
              isScrollable: true,
              tabs: months.map((month) => Tab(text: month)).toList(),
            ),
          ),
        ),
        body: TabBarView(
          children: List.generate(12, (index) {
            return Center(child: Text("Conteúdo de ${months[index]}"));
          }),
        ),
      ),
    );
  }
}
