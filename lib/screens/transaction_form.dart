import 'package:bytebank/http/webclientes/transaction_webclient.dart';
import 'package:bytebank/utils.dart/snackbar_app.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../models/transaction.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  const TransactionForm({Key? key, required this.contact}) : super(key: key);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController valueController = TextEditingController();
  final CurrencyTextInputFormatter currencyFormatter = CurrencyTextInputFormatter(
    locale: 'pt-BR',
    name: 'R\$ '
  );
  final TransactionWebclient webClient = TransactionWebclient();
  Widget childButton = const ChildButtonText();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _transfer(double value) async {
    if (_formKey.currentState!.validate()) {
      setState(() => childButton = const ChildButtonProgressIndicator());

      final transactionCreated = Transaction(value: value, contact: widget.contact);
      try {
        await webClient.save(transactionCreated)
            .then((value) async {
              if(value == null){
                showError();
              } else {
                await Future.delayed(const Duration(milliseconds: 500), () {
                  setState(() => childButton = const ChildButtonConfirm());
                });
                backOnSuccess(transactionCreated);
              }
            });
      } catch (e) {
        showError();
      }
    }
  }

  void showError() {
    showSnackBar(webClient.error!, true);
    setState(() => childButton = const ChildButtonText());
  } 

  void backOnSuccess(Transaction transaction) => Navigator.pop(context);

  void showSnackBar(String message, bool isError) {
    SnackBarApp.showSnackBar(
      context: context, 
      message: message,
      isError: isError
    );
  }

  String? validator(double? value) {
    if (value == null) {
        return 'Insira um valor válido';
    } else if (value < 1) {
      return 'Valor baixo demais';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova transferência'),
      ),
      body: Padding(
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
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextFormField(
                  controller: valueController,
                  inputFormatters: [currencyFormatter],
                  style: const TextStyle(fontSize: 24.0),
                  decoration: const InputDecoration(labelText: 'Value'),
                  validator: (value) => validator(currencyFormatter.getUnformattedValue().toDouble()),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onFieldSubmitted: (String value) {
                    if (value.isNotEmpty) {
                      _transfer(currencyFormatter.getUnformattedValue().toDouble());
                    } else {}
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                height: 48,
                width: double.maxFinite,
                child: ElevatedButton(
                  child: childButton,
                  onPressed: () => valueController.text.isNotEmpty
                      ? _transfer(currencyFormatter.getUnformattedValue().toDouble())
                      : null,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ChildButtonText extends StatelessWidget {
  const ChildButtonText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('Transfer');
  }
}

class ChildButtonProgressIndicator extends StatelessWidget {
  const ChildButtonProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 24.0,
      width: 24.0,
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }
}

class ChildButtonConfirm extends StatelessWidget {
  const ChildButtonConfirm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.check,
      size: 30.0,
    );
  }
}
