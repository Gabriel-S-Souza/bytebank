import 'package:bytebank/http/webclientes/transaction_webclient.dart';
import 'package:bytebank/utils.dart/snackbar_app.dart';
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
  final TextEditingController _valueController = TextEditingController();
  final TransactionWebclient webClient = TransactionWebclient();
  Widget _childButton = const _ChildButtonText();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _transfer(String value) {
    if (_formKey.currentState!.validate()) {
      setState(() => _childButton = const _ChildButtonProgressIndicator());
      final double value = double?.tryParse(_valueController.text.replaceAll(',', '.'))!;

      final transactionCreated = Transaction(value: value, contact: widget.contact);
      webClient.save(transactionCreated)
          .then((transaction) {
            if (transaction?.body != null && transaction!.body.contains('error')) {
              showSnackBar(webClient.error ?? 'Erro ao tranferir', true);
            }
            Future.delayed(const Duration(milliseconds: 1200), () {
              setState(() => _childButton = const _ChildButtonConfirm());
            }).then((value) => Navigator.pop(context, transactionCreated));
          })
          .catchError((err) {
            showSnackBar(err, true);
          });
    }
  }

  void showSnackBar(String message, bool isError) {
    SnackBarApp.showSnackBar(
      context: context, 
      message: message,
      isError: isError
    );
  }

  String? _validator(String? value) {
    if (double.tryParse(value!.replaceAll(',', '.')) == null) {
        return 'Insira um valor válido';
    } else if (double.tryParse(value.replaceAll(',', '.'))! < 0.10) {
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
                  controller: _valueController,
                  style: const TextStyle(fontSize: 24.0),
                  decoration: const InputDecoration(labelText: 'Value'),
                  validator: _validator,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onFieldSubmitted: (String value) {
                    if (value.isNotEmpty) {
                      _transfer(value);
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
                  child: _childButton,
                  onPressed: () => _valueController.text.isNotEmpty
                      ? _transfer(_valueController.text)
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

class _ChildButtonText extends StatelessWidget {
  const _ChildButtonText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('Transfer');
  }
}

class _ChildButtonProgressIndicator extends StatelessWidget {
  const _ChildButtonProgressIndicator({Key? key}) : super(key: key);

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

class _ChildButtonConfirm extends StatelessWidget {
  const _ChildButtonConfirm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.check,
      shadows: [
        BoxShadow(
          spreadRadius: 4
        )
      ],
    );
  }
}
