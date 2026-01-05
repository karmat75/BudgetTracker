import 'package:drift/drift.dart';
import '../Database/database.dart';

class AccountRepository {
  final AppDatabase _db;

  AccountRepository(this._db);

  // Alle aktiven Accounts abrufen
  Future<List<Account>> getAllAccounts() async {
    return await (_db.select(_db.accounts)
          ..where((a) => a.isActive.equals(true))
          ..orderBy([(a) => OrderingTerm.asc(a.name)]))
        .get();
  }

  // Account nach ID abrufen
  Future<Account?> getAccountById(int id) async {
    return await (_db.select(_db.accounts)..where((a) => a.id.equals(id)))
        .getSingleOrNull();
  }

  // Reactive Stream - UI aktualisiert sich automatisch!
  Stream<List<Account>> watchAllAccounts() {
    return (_db.select(_db.accounts)
          ..where((a) => a.isActive.equals(true))
          ..orderBy([(a) => OrderingTerm.asc(a.name)]))
        .watch();
  }

  // Account erstellen
  Future<int> createAccount(AccountsCompanion account) async {
    return await _db.into(_db.accounts).insert(account);
  }

  // Account aktualisieren
  Future<bool> updateAccount(Account account) async {
    return await _db.update(_db.accounts).replace(account);
  }

  // Account löschen (soft delete - isActive = false)
  Future<int> deleteAccount(int id) async {
    return await (_db.update(_db.accounts)..where((a) => a.id.equals(id)))
        .write(AccountsCompanion(
      isActive: const Value(false),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // Account Balance aktualisieren
  Future<int> updateAccountBalance(int id, double newBalance) async {
    return await (_db.update(_db.accounts)..where((a) => a.id.equals(id)))
        .write(AccountsCompanion(
      balance: Value(newBalance),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // Gesamtsaldo aller Accounts berechnen
  Future<double> getTotalBalance() async {
    final query = _db.selectOnly(_db.accounts)
      ..addColumns([_db.accounts.balance.sum()])
      ..where(_db.accounts.isActive.equals(true));

    final result = await query.getSingle();
    return result.read(_db.accounts.balance.sum()) ?? 0.0;
  }
}
