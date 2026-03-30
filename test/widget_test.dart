import 'package:flutter_test/flutter_test.dart';
import 'package:bean_model/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BeanCropDoctorApp());

    // Verify that the app title is displayed
    expect(find.text('Bean Crop Doctor'), findsOneWidget);
  });
}
