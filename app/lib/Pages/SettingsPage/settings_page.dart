import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Einstellungen'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Icon(
              Icons.settings,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'App-Einstellungen',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              'Hier können Sie die App-Einstellungen ändern',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ),
          const SizedBox(height: 30),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Design'),
            subtitle: const Text('Farbschema und Theme'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Design-Einstellungen
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Benachrichtigungen'),
            subtitle: const Text('Benachrichtigungseinstellungen'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Benachrichtigungseinstellungen
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Sprache'),
            subtitle: const Text('Deutsch'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Spracheinstellungen
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Über'),
            subtitle: const Text('Version und Informationen'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Über-Seite
            },
          ),
        ],
      ),
    );
  }
}
