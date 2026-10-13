import 'package:flutter/material.dart';
import 'package:nota_1000/presentation/widgets/custom_appbar.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Quiz Page',
        showBackButton: true,
      ),
      body: const Center(
        child: Text('This is the Quiz Page'),
      ),
    );
  }
}