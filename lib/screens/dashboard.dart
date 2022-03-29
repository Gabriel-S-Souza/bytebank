import 'package:bytebank/screens/contacts_list.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bytebank"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/bytebank_logo.png',
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FeatureItem(
                    text: 'Transfer',
                    icon: Icons.monetization_on,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ContactsList()));
                    }
                  ),
                  _FeatureItem(
                    text: 'Transatin feed',
                    icon: Icons.description,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ContactsList()));
                    }
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final void Function()? onTap;

  const _FeatureItem(
      {Key? key, required this.text, required this.icon, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Material(
        color: Theme.of(context).colorScheme.primary,
        child: InkWell(
          //Navegação:
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(8),
            height: 100,
            width: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 32,
                ),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
