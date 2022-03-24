import 'package:flutter/material.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
      ),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              title: Text(
                "Gabriel",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              subtitle: Text(
                "1234",
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}