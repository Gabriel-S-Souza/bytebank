import 'package:bytebank/custom_widgets/custom_loading.dart';
import 'package:flutter/material.dart';

import '../http/webclient.dart';
import '../models/contact.dart';
import '../models/transaction.dart';

class TransactionsList extends StatelessWidget {
  final List<Transaction> transactions = [];

  TransactionsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    transactions
        .add(Transaction(value: 100.0, contact: Contact(0, 'Alex', 1000)));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: FutureBuilder<List<Transaction>>(
        future: findAll(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {

            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return const CustomLoading();
            case ConnectionState.active:
              //Retorna partes carregadas do conteúdo -> Stream
              break;
            case ConnectionState.done:
              snapshot.data?.forEach((transaction) => transactions.add(transaction));
              return ListView.builder(
                itemBuilder: (context, index) =>
                    _TransactionItem(transaction: transactions[index]),
                itemCount: transactions.length,
              );
          }
          return const Text("Unknown Error");
        },
      )
    );
  }
}


class _TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const _TransactionItem({ Key? key, 
  required this.transaction
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.monetization_on),
        title: Text(
          transaction.value.toString(),
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          transaction.contact.accountNumber.toString(),
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}