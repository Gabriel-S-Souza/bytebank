import 'package:bytebank/custom_widgets/centered_message.dart';
import 'package:bytebank/custom_widgets/custom_loading.dart';
import 'package:flutter/material.dart';

import '../http/webclient.dart';
import '../models/transaction.dart';

class TransactionsList extends StatelessWidget {
  final List<Transaction> transactions = [];

  TransactionsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Transactions'),
        ),
        body: FutureBuilder<List<Transaction?>?>(
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
                if (snapshot.hasData) {
                  snapshot.data?.forEach(
                      (transaction) => transactions.add(transaction!));
                  if (transactions.isNotEmpty) {
                    return ListView.builder(
                      itemBuilder: (context, index) =>
                          _TransactionItem(transaction: transactions[index]),
                      itemCount: transactions.length,
                    );
                  }
                }
                return const CustomCenteredMessage(
                  message: "No transactions found",
                  icon: Icons.warning,
                );
            }

            return const CustomCenteredMessage(
                message: "Unknown Error", icon: Icons.error);
          },
        ));
  }
}

class _TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const _TransactionItem({Key? key, required this.transaction})
      : super(key: key);

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
          '${transaction.contact.name} - Account: ${transaction.contact.accountNumber.toString()}',
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
