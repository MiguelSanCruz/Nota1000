import 'package:flutter/material.dart';
import 'package:nota_1000/presentation/widgets/custom_appbar.dart';

class AnswersPage extends StatelessWidget {
  const AnswersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tratamento seguro para evitar erro de tipo (TypeError) com a lista de argumentos
    final args = ModalRoute.of(context)?.settings.arguments;
    final List<Map<String, dynamic>> respostas = args is List
        ? args.map((e) => Map<String, dynamic>.from(e)).toList()
        : [];

    // Calcula total de acertos
    final int totalAcertos = respostas.where((r) => r['isCorrect'] == true).length;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Gabarito do Simulado',
        showBackButton: false, // Evita voltar para o quiz ativo
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumo do desempenho
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF405ffc).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Você acertou $totalAcertos de ${respostas.length} questões.',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF405ffc),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),

            // Lista de perguntas em formato de barra
            Expanded(
              child: ListView.builder(
                itemCount: respostas.length,
                itemBuilder: (context, index) {
                  final item = respostas[index];
                  final questao = item['question'];
                  final String selectedLetter = item['selectedLetter'];
                  final bool isCorrect = item['isCorrect'];

                  // Encontra o texto da alternativa escolhida e da alternativa correta
                  final altEscolhida = questao.alternatives.firstWhere(
                    (alt) => alt.letter == selectedLetter,
                  );
                  final altCorreta = questao.alternatives.firstWhere(
                    (alt) => alt.isCorrect == true,
                  );

                  // Cor da barra: Verde se acertou, Vermelha se errou
                  final Color barColor = isCorrect ? Colors.green.shade600 : Colors.red.shade600;
                  final Color backgroundColor = isCorrect ? Colors.green.shade50 : Colors.red.shade50;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      border: Border.all(color: barColor, width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      title: Text(
                        'Questão ${index + 1} - ${questao.materia} (${questao.year})',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: barColor,
                        ),
                      ),
                      subtitle: Text(
                        isCorrect ? 'Acertou (Sua resposta: $selectedLetter)' : 'Errou (Sua resposta: $selectedLetter)',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Enunciado / Contexto resumido ou completo
                              if (questao.context.isNotEmpty) ...[
                                Text(
                                  questao.context,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                                ),
                                const SizedBox(height: 8),
                              ],
                              Text(
                                questao.alternativesIntroduction,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Divider(height: 24),

                              // Resposta do Usuário
                              Text(
                                'Sua resposta: $selectedLetter) ${altEscolhida.text}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isCorrect ? Colors.green.shade800 : Colors.red.shade800,
                                ),
                              ),
                              const SizedBox(height: 6),

                              // Resposta Correta (caso tenha errado)
                              if (!isCorrect) ...[
                                Text(
                                  'Resposta correta: ${altCorreta.letter}) ${altCorreta.text}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade800,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Botão para voltar à tela inicial
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
                onPressed: () {
                  // Volta para a tela inicial limpando a pilha de navegação (ou use '/home')
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home', // Altere para a rota da sua tela inicial/home se necessário
                    (route) => false,
                  );
                },
                child: const Text(
                  'Voltar para a Tela Inicial',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}