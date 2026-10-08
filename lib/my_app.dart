import 'package:nota_1000/app_Controller.dart';
import 'package:flutter/material.dart';
import 'package:nota_1000/login_page.dart';
import 'package:nota_1000/home_page.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppTheme.instance,
      builder: (context, child){
        return MaterialApp(
          theme:ThemeData(
            brightness: AppTheme.instance.isDarkMode ? Brightness.dark : Brightness.light,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => LoginPage(),
            '/home': (context) => HomePage(),
          },
        );
      }
    );
  }
}
