import 'dart:convert';

import 'package:bytebank/models/contact.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

import '../models/transaction.dart';

//Instanciando o client interceptado
Client client = InterceptedClient.build(interceptors: [
  LoggingInterceptor(),
]);

const String urlAuthority = 'crudcrud.com';
const String urlPath = 'api/bbe0815b844f48fda1b1e6f628c235d9/transactions';

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
    print('body ${data.body}');
    return data;
  }
}

Future<List<Transaction?>?> findAll() async {
  late final Response response;
  try {
    response = await client.get(Uri.https(urlAuthority, urlPath));
  } catch (e) {
    print('Erro capturado $e');
  }

  final List<Transaction> transactions = [];

  if (response.statusCode == 200) {
    final List<dynamic> decodedJson = jsonDecode(response.body);

    for (Map<String, dynamic> transactionJson in decodedJson) {
      final Transaction transaction = Transaction(
          value: transactionJson['value'] ,
          contact: Contact(
            0, 
            transactionJson['contact']['name'], transactionJson['contact']['accountNumber']
          )
          );
      transactions.add(transaction);
    }
    return transactions;
  } else {
    // throw Exception('Não foi possível carregar as transações');
    return null;
  }
}

Future<Transaction> save(Transaction transaction) async {
  //TODO: atenção utilizar dados que não são String dentro do jsonEncode
  final String transactionJson = jsonEncode(
  {
    'value': transaction.value,
    'contact': {
      'name': transaction.contact.name,
      'accountNumber': transaction.contact.accountNumber
    }
  });

  final Response response = await client.post(
    Uri.https(urlAuthority, urlPath),
    headers: {'Content-Type': 'application/json'},
    body: transactionJson,
  );
  
  final Map<String, dynamic> json = jsonDecode(response.body);

  return Transaction(
      value: json['value'],
      contact: Contact(
        0, 
        json['contact']['name'], 
        json['contact']['accountNumber']
      )
    );

}
