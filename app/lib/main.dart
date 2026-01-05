import 'package:flutter/material.dart';
import 'CommonElements/Navigation/bottom_navigation.dart';
import 'Data/Services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisiere die Datenbank beim App-Start
  await DatabaseService().initialize();

  runApp(const BudgetTrackerApp());
}

class BudgetTrackerApp extends StatelessWidget {
  const BudgetTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BottomNavigationShell(),
    );
  }
}
