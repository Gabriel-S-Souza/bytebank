import 'package:intl/intl.dart';

import 'contact.dart';

class Transaction {
  final double value;
  final Contact contact;
  final DateTime? date;

  Transaction({
    required this.value,
    required this.contact,
    this.date,
  });

  Transaction.fromJson(Map<String, dynamic> json)
      : value = json['value'],
        contact = Contact.fromJson(json['contact']),
        date = DateTime.parse(json['date']);
        // date = DateTime.parse(_convertDateTimeToDefault(json['date']));
  
  Map<String, dynamic> toJson() => {
        'value': value,
        'contact': contact.toJson(),
        'date': _getDateTime(),
      };

  String _getDateTime() {
    final dateTime = DateTime.now();
    return dateTime.toString();
  }

  @override
  String toString() {
    return 'Transaction{value: $value, contact: $contact}';
  }
}
