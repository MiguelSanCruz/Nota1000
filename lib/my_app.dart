import 'presentation/controllers/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:nota_1000/presentation/views/login/login_page.dart';
import 'package:nota_1000/presentation/views/home/home_page.dart';
import 'package:nota_1000/presentation/views/quiz/quiz_page.dart';
import 'package:nota_1000/presentation/views/answers/answers_page.dart';
import 'core/constants/app_colors.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppTheme.instance,
      builder: (context, child){
        final bool isDark = AppTheme.instance.isDarkMode;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode:AppTheme.instance.isDarkMode 
              ? ThemeMode.dark 
              : ThemeMode.light,

          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            primaryColor: AppColors.primaryLight,
            scaffoldBackgroundColor: AppColors.backgroundLight,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primaryLight,
              brightness: Brightness.light,
              primary: AppColors.primaryLight,
          )
          ),

          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            primaryColor: AppColors.primaryDark,
            scaffoldBackgroundColor: AppColors.backgroundDark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primaryDark,
              brightness: Brightness.dark,
              primary: AppColors.primaryDark,
              surface: AppColors.surfaceDark,
          )
          ),

          initialRoute: '/',
          routes: {
            '/': (context) => LoginPage(),
            '/home': (context) => HomePage(),
            '/quiz': (context) => QuizPage(configuracao: ModalRoute.of(context)!.settings.arguments as Map<String, int>),
            '/answers': (context) => const AnswersPage(),
          },
        );
      }
    );
  }
}
