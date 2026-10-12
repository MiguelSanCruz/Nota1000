import 'presentation/controllers/app_Controller.dart';
import 'package:flutter/material.dart';
import 'package:nota_1000/presentation/views/login/login_page.dart';
import 'package:nota_1000/presentation/views/home/home_page.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppTheme.instance,
      builder: (context, child){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
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
