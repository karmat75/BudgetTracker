import '../Database/database.dart';
import '../Repositories/account_repository.dart';
import '../Repositories/transaction_repository.dart';

// Singleton Service für Datenbank-Zugriff
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  late final AppDatabase _database;
  late final AccountRepository accountRepository;
  late final TransactionRepository transactionRepository;

  // Initialisierung der Datenbank
  Future<void> initialize() async {
    _database = AppDatabase();
    accountRepository = AccountRepository(_database);
    transactionRepository = TransactionRepository(_database);
  }

  // Für direkten Datenbankzugriff (falls nötig)
  AppDatabase get database => _database;

  // Datenbank schließen (z.B. beim App-Shutdown)
  Future<void> close() async {
    await _database.close();
  }
}
