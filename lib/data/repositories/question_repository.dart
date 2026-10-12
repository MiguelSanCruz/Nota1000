import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question_model.dart';

class QuestionRepository {
  final String assetPath;

  QuestionRepository({this.assetPath = 'assets/json/questoes.json'});

  Future<List<QuestionModel>> loadQuestions() async {
    try {
      final String jsonString = await rootBundle.loadString(assetPath);
      final List<dynamic> decodedData = json.decode(jsonString);
      
      return decodedData
          .map((item) => QuestionModel.fromJson(item))
          .toList();
    } catch (e) {
      print('Erro ao carregar o arquivo JSON de questões: $e');
      return [];
    }
  }

  Future<List<QuestionModel>> getQuestionsByMateria(String materia) async {
    final allQuestions = await loadQuestions();
    if (materia.isEmpty || materia.toLowerCase() == 'todas') {
      return allQuestions;
    }
    return allQuestions
        .where((q) => q.materia.toLowerCase() == materia.toLowerCase())
        .toList();
  }

  Future<List<QuestionModel>> getQuestionsByDiscipline(String discipline) async {
    final allQuestions = await loadQuestions();
    if (discipline.isEmpty || discipline.toLowerCase() == 'todas') {
      return allQuestions;
    }
    return allQuestions
        .where((q) => q.discipline.toLowerCase() == discipline.toLowerCase())
        .toList();
  }
}
