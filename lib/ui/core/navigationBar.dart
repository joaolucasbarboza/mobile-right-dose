import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:tcc/ui/core/setting_screen.dart';

import '../medicine/widgets/medicine_screen.dart';
import '../prescription/widgets/prescriptions_screen.dart';
import 'home_screen.dart';

class NavigationComponent extends StatefulWidget {
  final int initialIndex; // <-- add

  const NavigationComponent({super.key, this.initialIndex = 0}); // <-- default 0

  @override
  State<NavigationComponent> createState() => _NavigationComponentState();
}

class _NavigationComponentState extends State<NavigationComponent> {
  late int currentPageIndex; // <-- late

  final double sizeIcon = 22;
  final double sizeBig = 26;

  final List<Widget> pages = const [
    HomeScreen(),
    PrescriptionsScreen(),
    MedicineScreen(),
    SettingScreen(),
  ];

  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.initialIndex; // <-- usa o initialIndex
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // dica: IndexedStack preserva estado das páginas
      body: IndexedStack(index: currentPageIndex, children: pages),
      bottomNavigationBar: Container(
        height: 110,
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
        ),
        child: NavigationBar(
          height: 60, // 10 fica muito apertado
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          backgroundColor: Colors.white,
          animationDuration: const Duration(milliseconds: 200),
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade500),
          ),
          selectedIndex: currentPageIndex,
          onDestinationSelected: (i) => setState(() => currentPageIndex = i),
          destinations: [
            NavigationDestination(icon: Icon(LucideIcons.house500, size: sizeBig), label: 'Início'),
            NavigationDestination(icon: Icon(LucideIcons.calendar500, size: sizeBig), label: 'Prescrições'),
            NavigationDestination(icon: Icon(LucideIcons.pill500, size: sizeBig), label: 'Remédios'),
            NavigationDestination(icon: Icon(LucideIcons.settings500, size: sizeBig), label: 'Configurações'),
          ],
        ),
      ),
    );
  }
}