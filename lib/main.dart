import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_app/helpers/db_helper.dart';
import 'package:provider_app/providers/add_to_cart_provider.dart';
import 'package:provider_app/providers/theme_provider.dart';
import 'package:provider_app/views/screens/cart_page.dart';
import 'package:provider_app/views/screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.dbHelper.insertRecord();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => AddToCartProvider()),
      ],
      builder: (context, _) {
        return MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: (Provider.of<ThemeProvider>(context).isDark)
              ? ThemeMode.dark
              : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          routes: {
            "/": (context) => const HomePage(),
            "cart_page": (context) => const CartPage(),
          },
        );
      },
    ),
  );
}
