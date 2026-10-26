import 'package:flutter_test/flutter_test.dart';
import 'package:ob_havo/main.dart';

void main() {
  testWidgets('Weather API ilovasi ochilishi', (WidgetTester tester) async {
    // Ilovani ishga tushiramiz
    await tester.pumpWidget(const WeatherApp());

    // Bosh sahifadagi elementlar mavjudligini tekshiramiz
    expect(find.text('Weather API'), findsOneWidget);
    expect(find.text('Toshkent'), findsOneWidget);
    expect(find.text('22°C'), findsOneWidget);
    expect(find.text('5 kunlik ob-havo'), findsOneWidget);

    // Pastki navigatsiya
    expect(find.text('Bosh sahifa'), findsOneWidget);
    expect(find.text('Qidirish'), findsOneWidget);
    expect(find.text('Sevimlilar'), findsOneWidget);
    expect(find.text('Tarix'), findsOneWidget);
  });
}