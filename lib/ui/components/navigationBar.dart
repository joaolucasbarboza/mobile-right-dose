import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
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
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        child: NavigationBar(
          height: 60,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: Colors.lightGreen,
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Iconsax.home_copy),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.calendar_1_copy),
              label: 'Prescription',
            ),
            NavigationDestination(
              icon: Icon((Iconsax.layer_copy)),
              label: 'Medicine',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.setting_2_copy),
              label: 'Setting',
            ),
          ],
        ),
      ),
    );
  }
}