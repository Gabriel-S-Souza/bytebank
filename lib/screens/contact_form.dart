import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:bytebank/models/contact.dart';
import 'package:flutter/material.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({Key? key}) : super(key: key);

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final TextEditingController _nameControler = TextEditingController();
  final TextEditingController _accountNumberControler = TextEditingController();

  final ContactDao _contactDao = ContactDao();

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
                if (_nameControler.text.isNotEmpty && _accountNumberControler.text.isNotEmpty) {
                  final String name = _nameControler.text;
                  final int accountNumber = int.tryParse(_accountNumberControler
                    .text
                    .replaceAll(",", "")
                    .replaceAll(".", ""))!;
                  final Contact newContact = Contact(0, name, accountNumber);
                  _contactDao.save(newContact).then((id) => Navigator.pop(context, newContact));
                }
              },
              child: const Text("Create"),
            )
          ],
        ),
      ),
    );
  }
}
