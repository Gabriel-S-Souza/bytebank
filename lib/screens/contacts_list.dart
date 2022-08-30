import 'package:bytebank/custom_widgets/custom_loading.dart';
import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/screens/contact_form.dart';
import 'package:bytebank/screens/transaction_form.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  final ContactDao _contactDao = ContactDao();

  void _activateSnackbar(double value, String name) {
    final snackBar = SnackBar(
      content: Text('R\$${value.toStringAsFixed(2)} transferidos para $name'),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Find the ScaffoldMessenger in the widget tree
  // and use it to show a SnackBar.
  @override
  Widget build(BuildContext context) {
    List<Contact> contacts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer'),
      ),
      body: FutureBuilder<List<Contact>>(
          future: _contactDao.findAll(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                break;

              case ConnectionState.waiting:
                return const CustomLoading();

              case ConnectionState.active:
                break;

              case ConnectionState.done:
                contacts = snapshot.data as List<Contact>;
                return ListView.builder(
                  itemBuilder: (context, index) => _ContactItem(
                    contact: contacts[index],
                    onTap: () {
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                          builder: (context) => TransactionForm(
                            contact: contacts[index],
                          ),
                        ),
                      )
                          .then((transaction) {
                        if (transaction != null) {
                          _activateSnackbar(
                              transaction.value, transaction.contact.name);
                        }
                      });
                    },
                  ),
                  itemCount: contacts.length,
                );
            }
            return const Text('Unknown Error');
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          Navigator.of(context)
              .push(
                  MaterialPageRoute(builder: (context) => const ContactForm()))
              .then((newContact) =>
                  newContact != null ? setState(() => {}) : null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final Contact contact;
  final Function()? onTap;

  const _ContactItem({
    Key? key,
    required this.contact,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          contact.name,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        subtitle: Text(
          '${contact.accountNumber}',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        onTap: onTap,
      ),
    );
  }
}
