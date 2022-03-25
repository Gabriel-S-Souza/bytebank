import 'package:flutter/material.dart';

class ContactForm extends StatelessWidget {
  const ContactForm({ Key? key }) : super(key: key);

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
              decoration: const InputDecoration(
                labelText: "Full name",
              ),
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 24),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: "Account number",
                ),
                style: Theme.of(context).textTheme.labelMedium,
                keyboardType: TextInputType.number,
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Create"),
            )
          ],
        ),
      ),
    );
  }
}