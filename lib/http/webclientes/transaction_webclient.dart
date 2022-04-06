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
      'api/97e9817e4eea41b791229593e3f74002/transactions';

  Future<List<Transaction?>?> findAll() async {
    late final Response response;
    try {
      response = await client.get(Uri.https(urlAuthority, urlPath));
    } catch (e) {
      print('Erro capturado $e');
    }

    if (response.statusCode == 200) {
      final List<dynamic> decodedJson = jsonDecode(response.body);

      return decodedJson
          .map((dynamic json) => Transaction.fromJson(json))
          .toList();
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
    final List<dynamic> decodedJson = jsonDecode(responseFindAll.body);
    for (var transactionJson in decodedJson) {
      final dynamic id = transactionJson['_id'];
      final Response responseDeleteAll =
          await client.delete(Uri.https(urlAuthority, '$urlPath/$id'));
      print('Response delete: ${responseDeleteAll.body}');
    }
  }
}
