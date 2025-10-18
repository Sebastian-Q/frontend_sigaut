import 'package:flutter/material.dart';
import 'package:frontend/views/screen/categories_screen.dart';
import 'package:frontend/views/screen/login_screen.dart';
import 'package:frontend/views/screen/products_screen.dart';
import 'package:frontend/views/screen/profile_screen.dart';
import 'package:frontend/views/screen/register_screen.dart';
import 'package:frontend/views/screen/report_sale_screen.dart';
import 'package:frontend/views/screen/sale_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const routeName = '/home';

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (args) => const LoginScreen(),
        RegisterScreen.routeName: (args) => const RegisterScreen(),
        SaleScreen.routeName: (args) => const SaleScreen(),
        ProductsScreen.routeName: (args) => const ProductsScreen(),
        CategoriesScreen.routeName: (args) => const CategoriesScreen(),
        ProfileScreen.routeName: (args) => const ProfileScreen(),
        ReportSaleScreen.routeName: (args) => const ReportSaleScreen(),
      },
    );
  }
}