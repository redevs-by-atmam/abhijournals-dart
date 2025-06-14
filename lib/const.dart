import 'package:intl/intl.dart';

String getFormattedDate(DateTime date) {
  return DateFormat('dd-MM-yyyy').format(date);
}

