import 'package:bytebank/utils.dart/formatters.dart';

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
        date = Formatters.dateTimeFromBrString(json['date']);
  
  Map<String, dynamic> toJson() => {
        'value': value,
        'contact': contact.toJson(),
        'date': Formatters.dateFormattedFromDateTime(_getDateTime()),
      };

  DateTime _getDateTime() {
    return DateTime.now();
  }

  @override
  String toString() {
    return 'Transaction{value: $value, contact: $contact}';
  }
}
