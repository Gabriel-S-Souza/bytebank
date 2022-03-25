import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//Função responsável por criar o banco de dados
void createDataBase() {
  //Função do sqflite que permite obter o local de banco de dados padrão
  //Como ele retorna um Future<String>, podemos utilizar o then para acessá-lo
  getDatabasesPath().then((dataBasePath) {
    //Pegando o caminho junto com o nome de arquivo que defini
    final String path = join(dataBasePath, "bytebank.db");

    //Abra o banco de dados em um determinado caminho
    //podendo ainda especificar a versão do db que está sendo aberta -> isto é usado para realizar determinadas ações como onCreate
    openDatabase(path, onCreate: (db, version) {
      //aqui dentro podemos criar nossa tabela
      //Execute uma consulta SQL sem valor de retorno. Dentro dos parenteses vão comandos SQL compatíveis com SQLite
      db.execute('CREATE TABLE contacts('
        'id INTEGER PRYMARY KEY, '
        'name TEXT, '
        'account_number INTEGER)');
    }, version: 1);
  });
}
