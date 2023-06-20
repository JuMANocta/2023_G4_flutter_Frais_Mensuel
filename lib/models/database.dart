import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';

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

  // Créer une instance du système de fichiers local
  final LocalFileSystem localFileSystem = const LocalFileSystem();

  _initDatabase() async {
    try {
      print('base init');
      var documentDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentDirectory.path, _databaseName);

      // Créer une référence au fichier
      final File file = localFileSystem.file(path);

      if (await file.exists()) {
        // Si le fichier existe, afficher un toast avec le chemin du fichier
        Fluttertoast.showToast(
          msg: "👍Le fichier de base de données existe à : $path",
          toastLength: Toast.LENGTH_LONG,
        );
      } else {
        // Sinon, afficher un toast indiquant que le fichier n'existe pas
        Fluttertoast.showToast(
          msg: "💀Le fichier de base de données n'existe pas.",
          toastLength: Toast.LENGTH_LONG,
        );
      }

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
