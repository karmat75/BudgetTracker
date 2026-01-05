import 'package:drift/drift.dart';

// Accounts Table
class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().nullable()();
  RealColumn get balance => real().withDefault(const Constant(0.0))();
  TextColumn get currency =>
      text().withLength(min: 3, max: 3).withDefault(const Constant('EUR'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

// Transactions Table
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId =>
      integer().references(Accounts, #id, onDelete: KeyAction.cascade)();
  RealColumn get amount => real()();
  TextColumn get description => text().withLength(min: 1, max: 255)();
  TextColumn get category => text().nullable()();
  TextColumn get type =>
      text().withLength(min: 1, max: 50)(); // income, expense, transfer
  DateTimeColumn get transactionDate => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get notes => text().nullable()();
}

// Categories Table (für später)
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get icon => text().nullable()();
  TextColumn get color => text().nullable()();
  BoolColumn get isExpense => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
