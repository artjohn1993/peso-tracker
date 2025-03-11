import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key, required this.onNavigationBarEvent});

  final Function(int index) onNavigationBarEvent;

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  var navigationIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
        onDestinationSelected: (index) {
          setState(() {
            navigationIndex = index;
          });
          widget.onNavigationBarEvent(index);
        },
        selectedIndex: navigationIndex,
        destinations: [
          const NavigationDestination(icon: Icon(Icons.home), label: 'Dashboard'),
          const NavigationDestination(
              icon: Icon(Icons.area_chart), label: 'Transaction')
        ]);
  }
}
