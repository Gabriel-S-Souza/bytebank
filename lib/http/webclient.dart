import 'dart:convert';

import 'package:bytebank/models/contact.dart';
import 'package:bytebank/screens/transactions_list.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

import '../models/transaction.dart';

//O interceptador deve implementar a interface InterceptorContract
class LoggingInterceptor implements InterceptorContract {
  //Todo tipo de requyisição vai chamar este método
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    print('Request');
    // print('url ${data.baseUrl}');
    // print('headers ${data.headers}');
    // print('body ${data.body}');
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    print('Response');
    // print('status ${data.statusCode}');
    // print('headers ${data.headers}');
    // print('body ${data.body}');
    return data;
  }
}

Future<List<Transaction>> findAll() async {
  //Instanciando o client interceptado
  Client client = InterceptedClient.build(interceptors: [
    LoggingInterceptor(),
  ]);

  //método get.. Usando a partir do client interceptado
  final Response response = await client.get(Uri.https(
      'crudcrud.com', 'api/6a33eb89da004374a279747f65599f88/transactions'));

  final List<dynamic> decodedJson = jsonDecode(response.body);

  final List<Transaction> transactions = [];

  for (Map<String, dynamic> transactionJson in decodedJson) {
    final Transaction transaction = Transaction(
        value: double.parse(transactionJson['value']),
        contact: Contact(
            0, transactionJson['contact']['name'], int.parse(transactionJson['contact']['accountNumber'])
            )
        );
    transactions.add(transaction);
  }
  return transactions;
}
