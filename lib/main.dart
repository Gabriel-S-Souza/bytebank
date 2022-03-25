import 'dart:ui';

import 'package:bytebank/screens/contact_form.dart';
import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ByteBankApp());
}

class ByteBankApp extends StatelessWidget {
  const ByteBankApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green[900]!,
        ).copyWith(
          primary: Colors.green[900]!,
          secondary: Colors.blueAccent[700],
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueAccent[700],
          textTheme: ButtonTextTheme.primary,
        ),
        textTheme: const TextTheme(
          bodyText1: TextStyle(
            fontSize: 24,
          ),
          bodyText2: TextStyle(
            fontSize: 16,
          ),
          labelMedium: TextStyle(
            fontSize: 20,
          ),
        )
      ),
      home: const ContactForm(),
    );
  }
}