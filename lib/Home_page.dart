import 'package:flutter/material.dart';
import 'package:nota_1000/app_Controller.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NOTA 1000'),
          backgroundColor: const Color.fromARGB(255, 2, 139, 43),
            actions: [CustomTheme(),],
      ),
    );
  }
}


class CustomTheme extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Switch(
    value: AppTheme.instance.isDarkMode,
    onChanged: (value) {
      AppTheme.instance.changeTheme();
    },
    );
  }
}