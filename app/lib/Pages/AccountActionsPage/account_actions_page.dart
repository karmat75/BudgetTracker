import 'package:flutter/material.dart';

class AccountActionsPage extends StatefulWidget {
  const AccountActionsPage({super.key});

  @override
  State<AccountActionsPage> createState() => _AccountActionsPageState();
}

class _AccountActionsPageState extends State<AccountActionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Kontobewegungen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.swap_horiz,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),
            Text(
              'Kontobewegungen',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text(
              'Hier können Sie Kontobewegungen verwalten',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Bewegung hinzufügen
        },
        tooltip: 'Bewegung hinzufügen',
        child: const Icon(Icons.add),
      ),
    );
  }
}
