import 'package:drift/drift.dart';
import '../Database/database.dart';

class TransactionRepository {
  final AppDatabase _db;

  TransactionRepository(this._db);

  // Alle Transaktionen für ein Konto
  Future<List<Transaction>> getTransactionsByAccount(int accountId) async {
    return await (_db.select(_db.transactions)
          ..where((t) => t.accountId.equals(accountId))
          ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
        .get();
  }

  // Transaktionen in einem Zeitraum
  Future<List<Transaction>> getTransactionsByDateRange(
      DateTime start, DateTime end) async {
    return await (_db.select(_db.transactions)
          ..where((t) =>
              t.transactionDate.isBiggerOrEqualValue(start) &
              t.transactionDate.isSmallerOrEqualValue(end))
          ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
        .get();
  }

  // Reactive Stream - UI aktualisiert sich automatisch
  Stream<List<Transaction>> watchTransactionsByAccount(int accountId) {
    return (_db.select(_db.transactions)
          ..where((t) => t.accountId.equals(accountId))
          ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
        .watch();
  }

  // Transaktion erstellen
  Future<int> createTransaction(TransactionsCompanion transaction) async {
    return await _db.into(_db.transactions).insert(transaction);
  }

  // Transaktion aktualisieren
  Future<bool> updateTransaction(Transaction transaction) async {
    return await _db.update(_db.transactions).replace(transaction);
  }

  // Transaktion löschen
  Future<int> deleteTransaction(int id) async {
    return await (_db.delete(_db.transactions)..where((t) => t.id.equals(id)))
        .go();
  }

  // Einnahmen/Ausgaben für ein Konto berechnen
  Future<Map<String, double>> getAccountSummary(int accountId) async {
    final transactions = await getTransactionsByAccount(accountId);

    double income = 0.0;
    double expense = 0.0;

    for (var transaction in transactions) {
      if (transaction.type == 'income') {
        income += transaction.amount;
      } else if (transaction.type == 'expense') {
        expense += transaction.amount.abs();
      }
    }

    return {
      'income': income,
      'expense': expense,
      'balance': income - expense,
    };
  }

  // Transaktionen nach Kategorie filtern
  Future<List<Transaction>> getTransactionsByCategory(String category) async {
    return await (_db.select(_db.transactions)
          ..where((t) => t.category.equals(category))
          ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
        .get();
  }

  // Letzte N Transaktionen
  Future<List<Transaction>> getRecentTransactions(int limit) async {
    return await (_db.select(_db.transactions)
          ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)])
          ..limit(limit))
        .get();
  }
}
