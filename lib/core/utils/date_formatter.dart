import 'package:intl/intl.dart';

class DateFormatter {
  const DateFormatter();

  String format(DateTime dateTime) => DateFormat.yMMMd().format(dateTime);
}
