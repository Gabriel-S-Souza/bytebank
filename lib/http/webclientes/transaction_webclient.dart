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
      'api/74c00ad02a6d4f5196cff09efa77a0e7/transactions';

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

  save(Transaction transaction) async {
    Map<String, dynamic> transactionMap = transaction.toJson();
    String transactionJson = jsonEncode(transactionMap);

    final Response response = await client.post(
      Uri.https(urlAuthority, urlPath),
      headers: {'Content-Type': 'application/json'},
      body: transactionJson,
    );


    print('transactionJson: $transactionJson');

    // return _toTransactionFromJson(response);
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
      final Transaction transaction = Transaction.fromJson(transactionJson);
      transactions.add(transaction);
    }
    return transactions;
  }


  Transaction _toTransactionFromJson(Response response) {
    final Map<String, dynamic> json = jsonDecode(response.body);
    
    return Transaction.fromJson(json);
  }
}
