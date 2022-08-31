import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Formatters {
  static String moneyDisplay(double value) {
    final moneyMask = CurrencyTextInputFormatter(
      locale: 'pt-BR',
      name: 'R\$ '
    );

    String moneyFormated = moneyMask
        .formatEditUpdate(
          const TextEditingValue(text: ''),
          TextEditingValue(text: value.toStringAsFixed(2)),
        )
        .text;

    return moneyFormated;
  }

  static double money(String value) {
    value = value.replaceAll('R\$', '');
    value = value.replaceAll('.', '');
    value = value.replaceAll(',', '.');
    return double.tryParse(value) ?? 0;
  }

  static String date(String date) {
    final _date = DateTime.parse(date);
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(_date);
  }

  static DateTime dateTimeFromBrString(String date) {
    final String formattedDate;
    final dateWithoutSlash = date.replaceAll('/', '').trim();
    final String day = dateWithoutSlash.substring(0, 2);
    final String month = dateWithoutSlash.substring(2, 4);
    final String year = dateWithoutSlash.substring(4, 8);
    final String hours;
    final String minutes;
    if (dateWithoutSlash.length > 8) {
      minutes = dateWithoutSlash.substring(12, 14);
      hours = dateWithoutSlash.substring(9, 11);
      formattedDate = '$year-$month-$day $hours:$minutes:00';
    } else {
      formattedDate = '$year-$month-$day 00:00:00';
    }
    final DateTime dateTime = DateTime.parse(formattedDate);
    return dateTime;
  }

  static String dateFormattedFromDateTime(DateTime dateTime) {
    
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(dateTime);
  }

  // static String? _validateDate({String? value}) {
  //   if (value == null || value.isEmpty) {
  //     return 'Campo obrigatório';
  //   }

  //   final RegExp dateRegex =
  //     RegExp(r'[\d/]{2}/[\d/]{2}/[\d/]{4}');

  //   if(!(value.length == 10 && dateRegex.hasMatch(value))) {
  //     return 'Data inválida';
  //   } 
  //   return null;
  // }
}