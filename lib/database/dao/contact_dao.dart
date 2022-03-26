import 'package:sqflite/sqflite.dart';
import '../../models/contact.dart';
import '../app_database.dart';

class ContactDao {
  static const String tableSql = 'CREATE TABLE $tableName('
      '$_id INTEGER PRIMARY KEY AUTOINCREMENT, '
      '$_name TEXT, '
      '$_accountNumber INTEGER)';

  static const String _id = "id";
  static const String _name = "name";
  static const String _accountNumber = "account_number";

  static const String tableName = "contacts";

  Future<int> save(Contact contact) async {
    final Database db = await getDataBase();

    Map<String, dynamic> contactMap = _toMap(contact);

    return db.insert(tableName, contactMap);
  }

//Definindo uma função para buscar todos os contatos
  Future<List<Contact>> findAll() async {
    final Database db = await getDataBase();

    List<Map<String, dynamic>> dbMapsList = await db.query(tableName);

    List<Contact> contacts = _toList(dbMapsList);
    return contacts;
  }

  Map<String, dynamic> _toMap(Contact contact) {
    final Map<String, dynamic> contactMap = {};

    contactMap[_name] = contact.name;
    contactMap[_accountNumber] = contact.accountNumber;
    return contactMap;
  }

  List<Contact> _toList(List<Map<String, dynamic>> dbMapsList) {
    final List<Contact> contacts = [];

    for (Map<String, dynamic> row in dbMapsList) {
      contacts.add(Contact(row[_id], row[_name], row[_accountNumber]));
    }
    return contacts;
  }
}
