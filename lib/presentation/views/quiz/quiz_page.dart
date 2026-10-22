import 'package:flutter/material.dart';
import 'package:nota_1000/data/models/question_model.dart';
import 'package:nota_1000/data/repositories/question_repository.dart';
import 'package:nota_1000/presentation/widgets/custom_appbar.dart';

class QuizPage extends StatefulWidget {
  // Agora recebe o mapa de matérias e suas respetivas quantidades selecionadas
  final Map<String, int> configuracao;

  const QuizPage({Key? key, required this.configuracao}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final QuestionRepository _repository = QuestionRepository();
  
  List<QuestionModel> _questions = [];
  bool _isLoading = true;
  int _currentIndex = 0;
  String? _selectedAlternativeLetter;

  // Lista para salvar as respostas do aluno e mandar para o gabarito no final
  // Exemplo de item: {"question": questionModel, "selectedLetter": "A", "isCorrect": true/false}
  final List<Map<String, dynamic>> _respostasDoAluno = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final questions = await _repository.getQuestionsByMultipleMaterias(widget.configuracao);
    setState(() {
      _questions = questions;
      _isLoading = false;
    });
  }

  void _selectAlternative(String letter) {
    setState(() {
      _selectedAlternativeLetter = letter;
    });
  }

  void _avancarOuFinalizar() {
    if (_selectedAlternativeLetter == null) return;

    final questaoAtual = _questions[_currentIndex];
    
    // Descobre se a alternativa escolhida é a correta comparando com as alternativas do model
    final alternativaEscolhida = questaoAtual.alternatives.firstWhere(
      (alt) => alt.letter == _selectedAlternativeLetter,
    );
    
    // Salva a resposta no histórico do aluno
    _respostasDoAluno.add({
      'question': questaoAtual,
      'selectedLetter': _selectedAlternativeLetter,
      'isCorrect': alternativaEscolhida.isCorrect,
    });

    setState(() {
      _selectedAlternativeLetter = null;
      
      if (_currentIndex < _questions.length - 1) {
        _currentIndex++;
      } else {
        // Fim do quiz! Aqui você navega para a tela de gabarito enviando o histórico
        _finalizarSimulado();
      }
    });
  }

void _finalizarSimulado() {
  Navigator.pushReplacementNamed(
    context,
    '/answers', // Nome da rota que você acabou de registrar no my_app.dart
    arguments: _respostasDoAluno,
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Simulado',
        showBackButton: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF405FFC)),
            )
          : _questions.isEmpty
              ? const Center(
                  child: Text('Nenhuma questão encontrada para as matérias selecionadas.'),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subtítulo: Matéria e Progresso (X/X)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_questions[_currentIndex].materia} (${_questions[_currentIndex].year})',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF405ffc),
                            ),
                          ),
                          Text(
                            '${_currentIndex + 1}/${_questions.length}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Área de Texto rolável
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_questions[_currentIndex].context.isNotEmpty) ...[
                                Text(
                                  _questions[_currentIndex].context,
                                  style: const TextStyle(fontSize: 14, height: 1.5),
                                ),
                                const SizedBox(height: 16),
                              ],
                              if (_questions[_currentIndex].alternativesIntroduction.isNotEmpty) ...[
                                Text(
                                  _questions[_currentIndex].alternativesIntroduction,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],

                              // Alternativas (Sem mostrar verde/vermelho ao clicar)
                              ..._questions[_currentIndex].alternatives.map((alt) {
                                final isSelected = _selectedAlternativeLetter == alt.letter;
                                
                                final borderColor = isSelected 
                                    ? const Color(0xFF405ffc) 
                                    : Colors.grey.shade300;
                                final backgroundColor = isSelected 
                                    ? const Color(0xFF405ffc).withOpacity(0.05) 
                                    : Colors.white;

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: backgroundColor,
                                    border: Border.all(color: borderColor, width: 1.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: RadioListTile<String>(
                                    title: Text(
                                      '${alt.letter}) ${alt.text}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    value: alt.letter,
                                    groupValue: _selectedAlternativeLetter,
                                    activeColor: const Color(0xFF405ffc),
                                    onChanged: (val) {
                                      if (val != null) _selectAlternative(val);
                                    },
                                  ),
                                );
                              }).toList(),
                              const SizedBox(height: 24),

                              // Botão de Avançar / Próxima Questão
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF405ffc),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: _selectedAlternativeLetter == null
                                      ? null
                                      : _avancarOuFinalizar,
                                  child: Text(
                                    _currentIndex == _questions.length - 1 
                                        ? 'Finalizar Simulado' 
                                        : 'Próxima Questão',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}