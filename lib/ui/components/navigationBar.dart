import 'package:flutter/material.dart';
import 'package:tcc/ui/screens/prescription_screen.dart';
import 'package:tcc/ui/screens/setting_screen.dart';

import '../screens/home_screen.dart';
import '../screens/stock_screen.dart';

class NavigationComponent extends StatefulWidget {
  const NavigationComponent({super.key});

  @override
  State<NavigationComponent> createState() => _NavigationComponentState();
}

class _NavigationComponentState extends State<NavigationComponent> {
  int currentPageIndex = 0;

  final List<Widget> pages = [
    const HomeScreen(),
    const PrescriptionScreen(),
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
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined),
              selectedIcon: Icon(Icons.calendar_month_rounded),
              label: 'Prescription',
            ),
            NavigationDestination(
              icon: Icon(Icons.medication_outlined),
              selectedIcon: Icon(Icons.medication_rounded),
              label: 'Medicine',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings_rounded),
              label: 'Setting',
            ),
          ],
        ),
      ),
    );
  }
}