import 'package:flutter_test/flutter_test.dart';
import 'package:smart_gps_area/app.dart';
import 'package:smart_gps_area/injection/injection_container.dart';

void main() {
  setUpAll(() async {
    await configureDependencies();
  });

  testWidgets('launches the phase-one app shell', (tester) async {
    await tester.pumpWidget(const SmartGpsAreaApp());
    await tester.pumpAndSettle();

    expect(find.text('Smart GPS Fields'), findsOneWidget);
    expect(find.text('Project architecture shell'), findsOneWidget);
  });
}
