import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDataBase() async {
  final String dbPath = await getDatabasesPath();
  final String path = join(dbPath, 'bytebank_database.db');

  return openDatabase(path,
      onCreate: _onCreate, version: 1, onDowngrade: onDatabaseDowngradeDelete);
}

void _onCreate(Database db, int version) async {
  db.execute(ContactDao.tableSql);
}