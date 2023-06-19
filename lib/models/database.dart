import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static const _databaseName = "expenses.db";
  static const _databaseVersion = 1;

  static const table = 'expenses';

  static const columnId = 'id';
  static const columnDescription = 'description';
  static const columnAmount = 'amount';
  static const columnDate = 'date';

  // rendre cette classe de basedonnée en singleton
  DatabaseProvider._privateConstructor();
  static final DatabaseProvider instance =
      DatabaseProvider._privateConstructor();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    // créer une instance de la base de données
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    try {
      var documentDirectory = await getApplicationDocumentsDirectory();
      String path = documentDirectory.path + _databaseName;
      return await openDatabase(path,
          version: _databaseVersion, onCreate: _onCreate);
    } catch (e) {
      print('Erreur lors de l\'ouverture de la base de données : $e');
      return null;
    }
  }

  Future _onCreate(Database db, int version) async {
    // créer la table
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnDescription TEXT NOT NULL,
        $columnAmount REAL NOT NULL,
        $columnDate TEXT NOT NULL
      )
    ''');
  }
}
