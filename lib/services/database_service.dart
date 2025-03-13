import 'package:path/path.dart';
import 'package:peso_tracker/enum/enum.dart';
import 'package:peso_tracker/model/category_model.dart';
import 'package:peso_tracker/model/transaction_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:peso_tracker/enum/trackerDB.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();
  DatabaseService._constructor();
  static const tablename = "Table_Transaction";

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath =
        join(databaseDirPath, "${Trackerdb.Database_Tracker.name}.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
    CREATE TABLE ${Trackerdb.Table_Transaction.name} (
        ${Table_Tracker.id.name} TEXT PRIMARY KEY,
        ${Table_Tracker.date.name} TEXT NOT NULL,
        ${Table_Tracker.transactionType.name} TEXT NOT NULL,
        ${Table_Tracker.remarks.name} TEXT,
        ${Table_Tracker.amount.name} TEXT NOT NULL,
        ${Table_Tracker.category.name} TEXT NOT NULL,
        ${Table_Tracker.imagePath.name} TEXT NOT NULL)
  ''');

        db.execute('''
    CREATE TABLE ${Trackerdb.Table_Settings.name} (
        ${Table_Settings.id.name} int PRIMARY KEY,
        ${Table_Settings.authentication.name} int)
  ''');

   db.execute('''
    INSERT INTO ${Trackerdb.Table_Settings.name} VALUES (1,1)
  ''');

      },
    );
    return database;
  }

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  void updateSetting(int authentication) async {
    var db = await database;
    await db.update(
        Trackerdb.Table_Settings.name,
        {
          Table_Settings.authentication.name: authentication
        },
        where: '${Table_Settings.id.name} = ?',
        whereArgs: [1]);
  }

  Future<bool> getSettings() async {
    final db = await database;
    final data = await db.query(Trackerdb.Table_Settings.name);
    List<int> settings = data.map((item) => item[Table_Settings.authentication.name] as int).toList();
    return settings.isNotEmpty ? (settings[0] == 0 ? true : false) : false;
  }

  void addTransaction(TransactionModel transaction) async {
    final db = await database;
    await db.insert(tablename, {
      Table_Tracker.id.name: transaction.id,
      Table_Tracker.date.name: transaction.date.toString(),
      Table_Tracker.transactionType.name: transaction.transactionType.name,
      Table_Tracker.remarks.name: transaction.remarks,
      Table_Tracker.amount.name: transaction.amount.toString(),
      Table_Tracker.category.name: transaction.category.category.name,
      Table_Tracker.imagePath.name: transaction.category.imagepath,
    });
  }

  Future<List<TransactionModel>> getTransaction() async {
    final db = await database;
    final data = await db.query(Trackerdb.Table_Transaction.name);

    List<TransactionModel> transactionList = data
        .map(
          (item) => TransactionModel(
              id: item[Table_Tracker.id.name] as String,
              date: DateTime.parse(item[Table_Tracker.date.name] as String),
              remarks: item[Table_Tracker.remarks.name] as String,
              amount: double.parse(item[Table_Tracker.amount.name] as String),
              transactionType: TransactionType.values
                  .byName(item[Table_Tracker.transactionType.name] as String),
              category: CategoryModel(
                  category: Category.values
                      .byName(item[Table_Tracker.category.name] as String),
                  imagepath: item[Table_Tracker.imagePath.name] as String)),
        )
        .toList();

    transactionList.sort((a, b) => b.date.compareTo(a.date));
    print(transactionList);
    return transactionList;
  }

  void updateTransaction(TransactionModel transaction) async {
    var db = await database;
    await db.update(
        Trackerdb.Table_Transaction.name,
        {
          Table_Tracker.date.name: transaction.date.toString(),
          Table_Tracker.transactionType.name: transaction.transactionType.name,
          Table_Tracker.remarks.name: transaction.remarks,
          Table_Tracker.amount.name: transaction.amount.toString(),
          Table_Tracker.category.name: transaction.category.category.name,
          Table_Tracker.imagePath.name: transaction.category.imagepath,
        },
        where: '${Table_Tracker.id.name} = ?',
        whereArgs: [transaction.id]);
  }

  void deleteTransaction(TransactionModel transaction) async {
    var db = await database;
    await db.delete(Trackerdb.Table_Transaction.name,
        where: '${Table_Tracker.id.name} = ?', whereArgs: [transaction.id]);
  }
}
