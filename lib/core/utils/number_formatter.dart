import 'package:intl/intl.dart';

class NumberFormatter {
  const NumberFormatter();

  String formatMeasurement(double value) =>
      NumberFormat.decimalPatternDigits(decimalDigits: 2).format(value);
}
