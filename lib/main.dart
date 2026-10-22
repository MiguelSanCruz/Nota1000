import 'package:flutter/material.dart';
import 'package:nota_1000/my_app.dart';
import 'package:nota_1000/data/repositories/question_repository.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // CHAMA A INICIALIZAÇÃO DO BANCO AQUI
  try {
    // Substitua 'assets/caminho_do_seu_arquivo.json' pelo caminho exato do seu arquivo no projeto
    await QuestionRepository().inicializarBanco('assets/json/questoes.json');
    print("Banco de dados inicializado com sucesso!");
  } catch (e) {
    print("Erro ao inicializar o banco de dados: $e");
  }
  runApp(const MyApp());
}

