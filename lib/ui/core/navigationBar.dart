import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:tcc/ui/prescription/widgets/prescriptions_screen.dart';
import 'package:tcc/ui/core/setting_screen.dart';

import 'home_screen.dart';
import '../medicine/widgets/medicine_screen.dart';

class NavigationComponent extends StatefulWidget {
  const NavigationComponent({super.key});

  @override
  State<NavigationComponent> createState() => _NavigationComponentState();
}

class _NavigationComponentState extends State<NavigationComponent> {
  int currentPageIndex = 0;
  double sizeIcon = 22;
  double sizeBig = 26;

  final List<Widget> pages = [
    const HomeScreen(),
    const PrescriptionsScreen(),
    const MedicineScreen(),
    const SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPageIndex],
      bottomNavigationBar: ClipRRect(
        child: NavigationBar(
          height: 60,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: [
            NavigationDestination(
              icon: Icon(LucideIcons.house500, size: sizeBig,),
              selectedIcon: Icon(LucideIcons.house600, size: sizeIcon),
              label: 'Inicio',
            ),
            NavigationDestination(
              icon: Icon(LucideIcons.calendar500, size: sizeBig),
              selectedIcon: Icon(LucideIcons.calendar600, size: sizeIcon),
              label: 'Prescrições',
            ),
            NavigationDestination(
              icon: Icon(LucideIcons.pill500, size: sizeBig),
              selectedIcon: Icon(LucideIcons.pill600, size: sizeIcon),
              label: 'Remédios',
            ),
            NavigationDestination(
              icon: Icon(LucideIcons.settings500, size: sizeBig),
              selectedIcon: Icon(LucideIcons.settings600, size: sizeIcon),
              label: 'Configurações',
            ),
          ],
        ),
      ),
    );
  }
}