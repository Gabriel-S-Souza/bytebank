import 'package:bytebank/models/contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//Função responsável por pegar o banco de dados
//NOTA: A função que cria o db é passada como um parâmetro da openDatabase
Future<Database> getDataBase() async {
  final String dbPath = await getDatabasesPath();
  final String path = join(dbPath, "bytebank_database.db");

  return openDatabase(path, onCreate: _onCreate, version: 1);
}

void _onCreate(Database db, int version) async {
  db.execute('CREATE TABLE contacts('
      'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'name TEXT, '
      'account_number INTEGER)');
}

//Função para salvar cada contato no banco de dados
Future<int> save(Contact contact) async {
  final Database db = await getDataBase();

  //formatanto o valor a ser salvo do jeito que a insert pede
  final Map<String, dynamic> contactMap = {};

  contactMap["name"] = contact.name;
  contactMap["account_number"] = contact.accountNumber;

  return db.insert("contacts", contactMap);
}

//Definindo uma função para buscar todos os contatos
Future<List<Contact>> findAll() async {
  final Database db = await getDataBase();

  List<Map<String, dynamic>> dbMapsList = await db.query("contacts");

  final List<Contact> contacts = [];

  for (Map<String, dynamic> row in dbMapsList) {
    contacts.add(Contact(row["id"], row["name"], row["account_number"]));
  }
  return contacts;
}