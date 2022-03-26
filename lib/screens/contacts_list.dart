import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/screens/contact_form.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  final ContactDao _contactDao = ContactDao();

  @override
  Widget build(BuildContext context) {
    List<Contact> contacts;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
      ),
      body: FutureBuilder<List<Contact>>(
          //Este InitialData abaixo será renderizado (uma lista vazia) desde o início, antes da future ser resolvida
          // initialData: const [],
          //Nesta propriedade fica a nossa função assíncrona
          future: _contactDao.findAll(),
          //Assim que tiver uma resposta da pripriedade acima, ele irá modificar o código aqui dentro deste builder abaixo:
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                break;

              case ConnectionState.waiting:
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      Text("Loading")
                    ],
                  ),
                );

              case ConnectionState.active:
                //Retorna partes carregadas do conteúdo -> Stream
                break;

              case ConnectionState.done:
                contacts = snapshot.data as List<Contact>;
                return ListView.builder(
                  itemBuilder: (context, index) =>
                      _ContactItem(contact: contacts[index]),
                  itemCount: contacts.length,
                );
            }
            return const Text("Unknown Error");
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

  const _ContactItem({
    Key? key,
    required this.contact,
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
      ),
    );
  }
}
