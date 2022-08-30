import 'package:bytebank/custom_widgets/centered_message.dart';
import 'package:bytebank/custom_widgets/custom_loading.dart';
import 'package:bytebank/utils.dart/formatters.dart';
import 'package:flutter/material.dart';
import '../http/webclientes/transaction_webclient.dart';
import '../models/transaction.dart';

class TransactionsList extends StatelessWidget {
  final List<Transaction> transactions = [];
  final TransactionWebclient _webClient = TransactionWebclient();

  TransactionsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tranferências'),
        ),
        body: FutureBuilder<List<Transaction?>?>(
          future: _webClient.findAll(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                break;
              case ConnectionState.waiting:
                return const CustomLoading();
              case ConnectionState.active:
                break;
              case ConnectionState.done:
                if (snapshot.hasData) {
                  snapshot.data?.forEach(
                      (transaction) => transactions.insert(0, transaction!));
                  if (transactions.isNotEmpty) {
                    return ListView.builder(
                      itemBuilder: (context, index) =>
                          _TransactionItem(transaction: transactions[index]),
                      itemCount: transactions.length,
                    );
                  }
                }
                else {
                  return const CustomCenteredMessage(
                    message: 'No transactions found',
                    icon: Icons.warning,
                  );
                }
              }
             return const CustomCenteredMessage(
                message: 'Unknown Error', icon: Icons.error);
          },
      )
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final Transaction transaction;
  const _TransactionItem({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String value = Formatters.moneyDisplay(transaction.value);
    final String name = transaction.contact.name;
    final String account = transaction.contact.accountNumber.toString();
    final String date = Formatters.dateFormattedFromDateTime(transaction.date!);

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(
            Icons.monetization_on,
            color: Theme.of(context).colorScheme.primary,
          ),
          backgroundColor: Colors.transparent,
        ),
        contentPadding: const EdgeInsets.all(8),
        title: Text(
          value,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$name | $account',
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              date,
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
