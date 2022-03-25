import 'package:flutter/material.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({Key? key}) : super(key: key);

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final TextEditingController _nameControler = TextEditingController();
  final TextEditingController _accountNumberControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New contact"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameControler,
              decoration: const InputDecoration(
                labelText: "Full name",
              ),
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 24),
              child: TextField(
                controller: _accountNumberControler,
                decoration: const InputDecoration(
                  labelText: "Account number",
                ),
                style: Theme.of(context).textTheme.labelMedium,
                keyboardType: TextInputType.number,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final String name = _nameControler.text;
                final int? accountNumber = int.tryParse(
                    _accountNumberControler.text.replaceAll(",", ""));
              },
              child: const Text("Create"),
            )
          ],
        ),
      ),
    );
  }
}
