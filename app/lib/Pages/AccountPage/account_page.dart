import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../../Data/Services/database_service.dart';
import '../../Data/Database/database.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Konten'),
      ),
      body: StreamBuilder<List<Account>>(
        // Reactive Stream - UI aktualisiert sich automatisch bei Änderungen!
        stream: _dbService.accountRepository.watchAllAccounts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Fehler: ${snapshot.error}'));
          }

          final accounts = snapshot.data ?? [];

          if (accounts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_balance_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Keine Konten vorhanden',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Erstellen Sie Ihr erstes Konto mit dem + Button',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[500],
                        ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final account = accounts[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(
                      Icons.account_balance,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  title: Text(
                    account.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: account.description != null
                      ? Text(account.description!)
                      : null,
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${account.balance.toStringAsFixed(2)} ${account.currency}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: account.balance >= 0
                              ? Colors.green[700]
                              : Colors.red[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Aktiv',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // TODO: Account Details anzeigen
                  },
                  onLongPress: () {
                    _showAccountOptions(context, account);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAccountDialog(context),
        tooltip: 'Konto hinzufügen',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddAccountDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final balanceController = TextEditingController(text: '0.0');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Neues Konto erstellen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Kontoname',
                hintText: 'z.B. Girokonto',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Beschreibung (optional)',
                hintText: 'z.B. Hauptkonto bei Bank XY',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: balanceController,
              decoration: const InputDecoration(
                labelText: 'Startguthaben',
                suffixText: 'EUR',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () async {
              if (nameController.text.isEmpty) {
                return;
              }

              final account = AccountsCompanion(
                name: drift.Value(nameController.text),
                description: drift.Value(descriptionController.text.isEmpty
                    ? null
                    : descriptionController.text),
                balance:
                    drift.Value(double.tryParse(balanceController.text) ?? 0.0),
                currency: const drift.Value('EUR'),
                isActive: const drift.Value(true),
                createdAt: drift.Value(DateTime.now()),
              );

              await _dbService.accountRepository.createAccount(account);

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Konto erfolgreich erstellt')),
                );
              }
            },
            child: const Text('Erstellen'),
          ),
        ],
      ),
    );
  }

  void _showAccountOptions(BuildContext context, Account account) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Bearbeiten'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Account bearbeiten
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Löschen', style: TextStyle(color: Colors.red)),
            onTap: () async {
              Navigator.pop(context);
              await _dbService.accountRepository.deleteAccount(account.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Konto gelöscht')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
