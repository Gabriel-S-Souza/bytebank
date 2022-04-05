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
        // date = DateTime.parse(json['date']);
        date = DateTime.parse(_convertDateTimeToDefault(json['date']));
  Map<String, dynamic> toJson() => {
        'value': value,
        'contact': contact.toJson(),
        'date': _getDateTime(),
      };

  String _getDateTime() {
    final dateTime = DateTime.now();
    final dateTimeFormated = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    return dateTimeFormated.toString();
  }

  static String _convertDateTimeToDefault(String date) {
    final hour = date.substring(11, 16);
    String day = '';
    String month = '';
    String year = '';
    int numberOfSlash = 0;

    for (var i = 0; i < 10; i++) {
      if (date[i] != '/') {
        if (numberOfSlash == 0) {
          day += date[i];
        } else if (numberOfSlash == 1) {
          month += date[i];
        } else if (numberOfSlash == 2) {
          year += date[i];
        }
      } else {
        numberOfSlash++;
      }
    }

    String dateConverted = '$year-$month-$day $hour';
    print(dateConverted);
    return dateConverted;
  }

  @override
  String toString() {
    return 'Transaction{value: $value, contact: $contact}';
  }
}
