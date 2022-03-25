import 'package:bytebank/models/contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//Função responsável por criar o banco de dados
Future<Database> createDataBase() {
  //Função do sqflite que permite obter o local de banco de dados padrão
  //Como ele retorna um Future<String>, podemos utilizar o then para acessá-lo
  return getDatabasesPath().then((dataBasePath) {
    //Pegando o caminho junto com o nome de arquivo que defini
    final String path = join(dataBasePath, "bytebank.db");

    //Abra o banco de dados em um determinado caminho
    //podendo ainda especificar a versão do db que está sendo aberta -> isto é usado para realizar determinadas ações como onCreate
    return openDatabase(path, onCreate: (db, version) {
      //aqui dentro podemos criar nossa tabela
      //Execute uma consulta SQL sem valor de retorno. Dentro dos parenteses vão comandos SQL compatíveis com SQLite
      db.execute('CREATE TABLE contacts('
          'id INTEGER PRYMARY KEY, '
          'name TEXT, '
          'account_number INTEGER)');
    }, version: 1);
  });
}

//Função para salvar o contato
Future<int> save(Contact contact) {
  return createDataBase().then((db) {
    //Precisamos aqui formatar o valor a ser salvo do jeito que a função insert pede:
    final Map<String, dynamic> contactMap = {};

    contactMap['id'] = contact.id;
    contactMap['name'] = contact.name;
    contactMap['account_number'] = contact.accountNumber;

    //Aqui, a partir de db, podemos executar ações como inserir (salvar) na tabela, passando o nome dela e o valor a ser salvo:
    return db.insert("contacts", contactMap);
  });
}

//Definindo uma função para buscar todos os contatos
Future<List<Contact>> findAll() {
  return createDataBase().then((db) {
    return db.query("contacts").then((maps) {
      final List<Contact> contacts = [];

      for (Map<String, dynamic> map in maps) {
        final Contact contact = Contact(map["name"], map["account_number"], map["id"]);
        return contacts.add(contact);
      }
    });
  });
}

// ERRO:
// o corpo pode ser concluído corretamente, fazendo com que null seja retornado, mas o tipo de retorno
//  future ou list contacts é potencialmente do tipo não anulável. tente adicionar um retorno ou uma declaração 
//  de arremesso no final