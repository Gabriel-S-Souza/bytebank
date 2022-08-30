import 'dart:convert';

import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';

import '../../models/transaction.dart';
import '../interceptors/logging_interceptor.dart';

class TransactionWebclient {
  Client client = InterceptedClient.build(interceptors: [
    LoggingInterceptor(),
  ]);
  final String urlAuthority = 'crudapi.co.uk';
  final String urlPath =
      '/api/v1/transactions';
  final String apiToken = 'faWvWpDPuk0CI0GPPwTY3w438fIfvZSl_H0LWm6sIyteZwsATA';
  String? error;

  
  Future<List<Transaction?>?> findAll() async {
    late final Response response;
    try {
      response = await client.get(
        Uri.https(urlAuthority, urlPath),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );
    } catch (e) {
      print('Erro capturado $e');
    }

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);

      final transactions = (decodedJson['items'] as List)
          .map((dynamic json) => Transaction.fromJson(json))
          .toList();
      transactions.sort((a, b) => a.date!.compareTo(b.date!));
      return transactions;
    } else {
      return null;
    }
  }

  Future<Response?> save(Transaction transaction) async {
    Map<String, dynamic> transactionMap = transaction.toJson();
    String transactionJson = jsonEncode([transactionMap]);

    try {
      final Response response = await client.post(
      Uri.https(urlAuthority, urlPath),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiToken',
      },
      body: transactionJson,
    );
    return response;
    } catch (e) {
      error = e.toString();
      return null;
    }
  }

  Future<void> deleteAll() async {
    final Response responseFindAll =
        await client.get(Uri.https(urlAuthority, urlPath));
    final List<dynamic> decodedJson = jsonDecode(responseFindAll.body);
    for (var transactionJson in decodedJson) {
      final String? id = transactionJson['_id'];
      await client.delete(Uri.https(urlAuthority, '$urlPath/$id'));
    }
  }
}
