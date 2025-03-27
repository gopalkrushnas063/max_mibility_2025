import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  Future<Database> setDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'usersd_db.db');
    final database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
    return database;
  }

  Future<void> _createDatabase(Database database, int version) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY,
        name TEXT,
        contact TEXT,
        email TEXT,
        imagePath TEXT,
        latitude TEXT,
        longitude TEXT
      )
    ''');
  }
}
