import 'package:flutter/material.dart';

class ContactForm extends StatelessWidget {
  const ContactForm({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New contact"),
      ),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: "Full name",
            ),
            style: Theme.of(context).textTheme.labelMedium,
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: "Account number",
            ),
            style: Theme.of(context).textTheme.labelMedium,
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Create"),
          )
        ],
      ),
    );
  }
}