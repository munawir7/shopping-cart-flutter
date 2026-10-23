import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_cart_app/main.dart';

void main() {
testWidgets('Shopping Cart app displays the home screen', (
WidgetTester tester,
) async {
await tester.pumpWidget(const ShoppingCartApp());


expect(find.text('ShopEase'), findsOneWidget);
expect(find.text('Discover Products'), findsOneWidget);


});
}
