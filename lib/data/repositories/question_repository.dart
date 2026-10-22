import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import '../datasources/database_helper.dart';
import '../models/question_model.dart';

class QuestionRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // 1. Método que inicializa: verifica se o banco tem dados, senão lê o JSON e popula
  Future<void> inicializarBanco(String assetPath) async {
  final db = await _dbHelper.database;
  
  final countResult = Sqflite.firstIntValue(
    await db.rawQuery('SELECT COUNT(*) FROM questions'),
  );

  if (countResult == null || countResult == 0) {
    final String jsonString = await rootBundle.loadString(assetPath);
    final List<dynamic> decodedData = json.decode(jsonString);

    await db.transaction((txn) async {
      for (var item in decodedData) {
        // ATENÇÃO: Certifique-se de que item['index'] é único para cada questão no seu JSON
        final int questionIndex = item['index'];

        // Insere a questão
        await txn.rawInsert('''
          INSERT INTO questions (question_index, year, discipline, materia, context, alternativesIntroduction, correctAlternative)
          VALUES (?, ?, ?, ?, ?, ?, ?)
        ''', [
          questionIndex,
          item['year'],
          item['discipline'],
          item['materia'],
          item['context'],
          item['alternativesIntroduction'],
          item['correctAlternative'],
        ]);

        // Insere as alternativas vinculadas rigorosamente ao questionIndex desta questão
        for (var alt in item['alternatives']) {
          await txn.rawInsert('''
            INSERT INTO alternatives (question_index, letter, text, isCorrect)
            VALUES (?, ?, ?, ?)
          ''', [
            questionIndex, // Garante que usa o índice correto da questão atual do loop
            alt['letter'],
            alt['text'],
            alt['isCorrect'] == true ? 1 : 0,
          ]);
        }
      }
    });
  }
}


Future<List<QuestionModel>> getQuestionsByMateria(String materia, int limit) async {
  final db = await _dbHelper.database;
  List<Map<String, dynamic>> maps;
  
  // LOG DE DEBUG 1: Vamos ver o total geral de linhas na tabela 'questions'
  final totalNoBanco = Sqflite.firstIntValue(
    await db.rawQuery('SELECT COUNT(*) FROM questions'),
  ) ?? 0;
  print('=== DEBUG SQLITE === Total de questões cadastradas no banco: $totalNoBanco');

  if (totalNoBanco == 0) {
    print('=== ATENÇÃO === A tabela "questions" está VAZIA! O inicializarBanco não rodou ou o JSON não carregou.');
    return [];
  }


  if (materia.isEmpty || materia.toLowerCase() == 'todas') {
      // Usamos DISTINCT ou garantimos IDs únicos se necessário, 
      // mas o ideal aqui é buscar linhas únicas da tabela 'questions'
      maps = await db.query(
        'questions',
        orderBy: 'RANDOM()',
        limit: limit,
      );
    } else {
      maps = await db.query(
        'questions',
        where: 'LOWER(materia) LIKE ? OR LOWER(discipline) LIKE ?',
        whereArgs: ['%${materia.toLowerCase()}%', '%${materia.toLowerCase()}%'],
        orderBy: 'RANDOM()',
        limit: limit,
      );
    }

  print('=== DEBUG SQLITE === Para a matéria "$materia", foram encontradas: ${maps.length} questões');

  List<QuestionModel> questions = [];
  for (var map in maps) {
    final altMaps = await db.query(
      'alternatives',
      where: 'question_index = ?',
      whereArgs: [map['question_index']],
    );

    questions.add(QuestionModel.fromMap(map, altMaps));
  }

  return questions;
}
  // 3. NOVO: Busca questões para múltiplas matérias com suas respectivas quantidades no SQLite
  Future<List<QuestionModel>> getQuestionsByMultipleMaterias(
      Map<String, int> configuracao) async {
    List<QuestionModel> todasQuestoes = [];

    // Percorre cada matéria e a quantidade solicitada
    for (var entry in configuracao.entries) {
      final materia = entry.key;
      final quantidade = entry.value;

      // Ignora a chave "Todas" no loop se ela estiver presente no mapa
      if (materia.toLowerCase() == 'todas') continue;

      if (quantidade > 0) {
        // Busca do SQLite a quantidade sorteada exata para essa matéria
        final questoesMateria = await getQuestionsByMateria(materia, quantidade);
        todasQuestoes.addAll(questoesMateria);
      }
    }

    // Mistura (sorteia) a ordem final de todas as questões selecionadas do simulado
    todasQuestoes.shuffle();

    return todasQuestoes;
  }
}