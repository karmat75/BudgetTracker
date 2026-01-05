import 'package:flutter/material.dart';
import '../../Pages/MainPage/main_page.dart';
import '../../Pages/AccountPage/account_page.dart';
import '../../Pages/AccountActionsPage/account_actions_page.dart';
import '../../Pages/SettingsPage/settings_page.dart';

class BottomNavigationShell extends StatefulWidget {
  const BottomNavigationShell({super.key});

  @override
  State<BottomNavigationShell> createState() => _BottomNavigationShellState();
}

class _BottomNavigationShellState extends State<BottomNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const MainPage(),
    const AccountPage(),
    const AccountActionsPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Übersicht',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Konten',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Bewegungen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Einstellungen',
          ),
        ],
      ),
    );
  }
}
