import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:date_format/date_format.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

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
              icon: Icon(Iconsax.search_normal_1_copy),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Iconsax.notification_copy),
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
              icon: Icon(Iconsax.user_copy),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: TabBar(
              isScrollable: true,
              tabs: months.map((month) => Tab(text: month)).toList(),
            ),
          ),
        ),
        body: TabBarView(
          children: List.generate(
            12,
            (index) {
              return Center(
                child: Text("Conteúdo de ${months[index]}"),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> logoutUser() async {
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences.remove("token");
  }

  Future<bool> verifyUser() async {
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();

    String? token = _sharedPreferences.getString("token");

    if (token == null) {
      return false;
    } else {
      return true;
    }
  }
}
