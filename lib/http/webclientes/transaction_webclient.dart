import 'dart:convert';

import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../models/transaction.dart';
import '../interceptors/logging_interceptor.dart';

class TransactionWebclient {
  Client client = InterceptedClient.build(interceptors: [
    LoggingInterceptor(),
  ]);
  static const String urlAuthority = 'crudcrud.com';
  static const String urlPath =
      'api/f117db14a9784ffd9d4c9309e79c1149/transactions';

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

  Future<Response> save(Transaction transaction) async {
    Map<String, dynamic> transactionMap = transaction.toJson();
    String transactionJson = jsonEncode(transactionMap);

    final Response response = await client.post(
      Uri.https(urlAuthority, urlPath),
      headers: {'Content-Type': 'application/json'},
      body: transactionJson,
    );
    return response;
  }

  Future<void> deleteAll() async {
    final Response responseFindAll =
        await client.get(Uri.https(urlAuthority, urlPath));
    //make forEach in responseFindAll
    final List<dynamic> decodedJson = jsonDecode(responseFindAll.body);
    for (var transactionJson in decodedJson) {
      final dynamic id = transactionJson['_id'];
      final Response responseDeleteAll =
          await client.delete(Uri.https(urlAuthority, '$urlPath/$id'));
      print('Response delete: ${responseDeleteAll.body}');
    }
  }

  List<Transaction> _toTransactionsList(Response response) {
    final List<dynamic> decodedJson = jsonDecode(response.body);
    final List<Transaction> transactions = decodedJson
        .map((dynamic json) => Transaction.fromJson(json))
        .toList();

    return transactions;
  }
}
