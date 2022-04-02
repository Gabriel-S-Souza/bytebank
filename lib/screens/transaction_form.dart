import 'package:bytebank/http/webclientes/transaction_webclient.dart';
import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../models/transaction.dart';

final TransactionWebclient _webClient = TransactionWebclient();
class TransactionForm extends StatefulWidget {
  final Contact contact;
  const TransactionForm({Key? key, required this.contact}) : super(key: key);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();

  Widget? _childButton = const Text("Transfer");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.contact.name,
                style: const TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  widget.contact.accountNumber.toString(),
                  style: const TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: const TextStyle(fontSize: 24.0),
                  decoration: const InputDecoration(labelText: 'Value'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  height: 48,
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: _childButton,
                    onPressed: () {
                      if (_valueController.text.isNotEmpty) {
                        setState(() => _childButton = const SizedBox(
                          height: 24.0,
                          width: 24.0,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ));
                        final double value =
                          double?.tryParse(_valueController.text)!;

                      final transactionCreated =
                          Transaction(value: value, contact: widget.contact);
                      _webClient.save(transactionCreated)
                        .then((transaction) => Navigator.pop(context));
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
