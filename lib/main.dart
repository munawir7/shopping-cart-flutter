import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/theme/theme_provider.dart';
import 'features/cart/presentation/providers/cart_provider.dart';
import 'features/checkout/presentation/providers/checkout_provider.dart';
import 'features/products/presentation/providers/product_provider.dart';
import 'features/products/presentation/screens/home_screen.dart';
import 'features/wishlist/presentation/providers/wishlist_provider.dart';

void main() {
runApp(const ShoppingCartApp());
}

class ShoppingCartApp extends StatelessWidget {
const ShoppingCartApp({super.key});

@override
Widget build(BuildContext context) {
return MultiProvider(
providers: [
ChangeNotifierProvider<ProductProvider>(
create: (context) => ProductProvider(),
),
ChangeNotifierProvider<CartProvider>(
create: (context) => CartProvider(),
),
ChangeNotifierProvider<WishlistProvider>(
create: (context) => WishlistProvider(),
),
ChangeNotifierProvider<ThemeProvider>(
create: (context) => ThemeProvider(),
),
ChangeNotifierProvider<CheckoutProvider>(
create: (context) => CheckoutProvider(),
),
],

child: const ShoppingCartThemeApp(),
);
}
}

class ShoppingCartThemeApp extends StatelessWidget {
const ShoppingCartThemeApp({super.key});

@override
Widget build(BuildContext context) {
final themeProvider = context.watch<ThemeProvider>();


return MaterialApp(
  title: 'Shopping Cart',
  debugShowCheckedModeBanner: false,
  themeMode: themeProvider.themeMode,

  // Light theme.
  theme: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF8F7FC),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF8F7FC),
      foregroundColor: Color(0xFF211B2B),
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),
  ),

  // Dark theme.
  darkTheme: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFBCA7F5),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF121212),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E1E),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),
  ),

  home: const HomeScreen(),
);


}
}
