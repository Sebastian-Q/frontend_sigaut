import 'package:flutter/material.dart';
import 'package:frontend/views/screen/categories_screen.dart';
import 'package:frontend/views/screen/login_screen.dart';
import 'package:frontend/views/screen/products_screen.dart';
import 'package:frontend/views/screen/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: CategoriesScreen.routeName,
      routes: {
        LoginScreen.routeName: (args) => const LoginScreen(),
        RegisterScreen.routeName: (args) => const RegisterScreen(),
        ProductsScreen.routeName: (args) => const ProductsScreen(),
        CategoriesScreen.routeName: (args) => const CategoriesScreen(),
      },
    );
  }
}