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

  @override
  String toString() {
    return 'Transaction{value: $value, contact: $contact}';
  }
}
