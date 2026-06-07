import 'package:smart_gps_area/core/widgets/placeholder_page.dart';

class FieldDetailPage extends PlaceholderPage {
  const FieldDetailPage({required String fieldId, super.key})
    : super(title: 'Field Detail', subtitle: 'Field ID: $fieldId');
}
