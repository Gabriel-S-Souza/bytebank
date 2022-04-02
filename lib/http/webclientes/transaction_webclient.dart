import 'dart:convert';

import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../models/contact.dart';
import '../../models/transaction.dart';
import '../interceptors/logging_interceptor.dart';

class TransactionWebclient {
  Client client = InterceptedClient.build(interceptors: [
    LoggingInterceptor(),
  ]);
  static const String urlAuthority = 'crudcrud.com';
  static const String urlPath =
      'api/1822efaa21f941fd843a8d6e0e32cf8a/transactions';

  Future<List<Transaction?>?> findAll() async {
    late final Response response;
    try {
      response = await client.get(Uri.https(urlAuthority, urlPath));
    } catch (e) {
      print('Erro capturado $e');
    }

    if (response.statusCode == 200) {
      final List<Transaction> transactions = _toTransactionsList(response);
      return transactions;
    } else {
      return null;
    }
  }

  Future<Transaction> save(Transaction transaction) async {
    String transactionJson = _toJsonBody(transaction);

    final Response response = await client.post(
      Uri.https(urlAuthority, urlPath),
      headers: {'Content-Type': 'application/json'},
      body: transactionJson,
    );

    return _toTransactionFromJson(response);
  }

  Future<void> deleteAll() async {
    final Response responseFindAll =
        await client.get(Uri.https(urlAuthority, urlPath));
    //make forEach in responseFindAll
    final List<dynamic> decodedJson = jsonDecode(responseFindAll.body);
    decodedJson.forEach((transactionJson) async {
      final dynamic id = transactionJson['_id'];
      final Response responseDeleteAll =
          await client.delete(Uri.https(urlAuthority, '$urlPath/$id'));
      print('Response delete: ${responseDeleteAll.body}');
    });
  }

  List<Transaction> _toTransactionsList(Response response) {
    final List<Transaction> transactions = [];
    final List<dynamic> decodedJson = jsonDecode(response.body);

    for (Map<String, dynamic> transactionJson in decodedJson) {
      final Transaction transaction = Transaction(
          value: transactionJson['value'],
          date: DateTime.parse(transactionJson['date']),
          contact: Contact(0, transactionJson['contact']['name'],
              transactionJson['contact']['accountNumber']), );
      transactions.add(transaction);
    }
    return transactions;
  }


  Transaction _toTransactionFromJson(Response response) {
    final Map<String, dynamic> json = jsonDecode(response.body);
    
    return Transaction(
        value: json['value'],
        date: DateTime.parse(json['date']),
        contact: Contact(
            0, json['contact']['name'], json['contact']['accountNumber']),);
  }

  String _toJsonBody(Transaction transaction) {
    final String transactionJson = jsonEncode({
      'value': transaction.value,
      //faça uma chave e valor para registrar o horário atual
      'date': DateTime.now().toString().substring(0, 16),
      'contact': {
        'name': transaction.contact.name,
        'accountNumber': transaction.contact.accountNumber
      }
    });
    return transactionJson;
  }
}
