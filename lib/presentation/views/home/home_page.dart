import 'package:flutter/material.dart';
import 'package:nota_1000/presentation/views/quiz/quiz_page.dart';
import 'package:nota_1000/presentation/widgets/custom_appbar.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> question = [
    "Ingles",
    "Espanhol",
    "Portugues",
    "Artes",
    "Educacao Fisica",
    "Historia",
    "Geografia",
    "Filosofia",
    "Sociologia",
    "Matematica",
    "Fisica",
    "Quimica",
    "Biologia",
    "Todas"
  ];
  final TextEditingController _controllerNumeroPerguntas = TextEditingController(text: '0');
  bool temTempo = false;
  final Map<String, int> contadoresIndividuais = {};

  @override
  void initState() {
    super.initState();
    for (var materia in question) {
      contadoresIndividuais[materia] = 0;
    }
  }

  @override
  void dispose() {
    _controllerNumeroPerguntas.dispose();
    super.dispose();
  }

  void _iniciarQuiz() {
    int totalPerguntas = int.tryParse(_controllerNumeroPerguntas.text) ?? 0;

    // Altere a condição aqui para > 1 (ou >= 2)
    if (totalPerguntas > 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizPage(
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('O contador global precisa ser maior que 1 para começar!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _incrementarMateria(String materia) {
    setState(() {
      int totalAtual = int.tryParse(_controllerNumeroPerguntas.text) ?? 0;

      if (materia == "Todos") {
        // Se clicar em "Todos", adiciona 1 em todas as outras matérias (exceto o próprio "Todos")
        for (var m in question) {
          if (m != "Todos") {
            contadoresIndividuais[m] = (contadoresIndividuais[m] ?? 0) + 1;
          }
        }
        // Adiciona 13 no contador global
        totalAtual += 13;
        _controllerNumeroPerguntas.text = totalAtual.toString();
      } else {
        // Comportamento normal para os outros botões
        contadoresIndividuais[materia] = (contadoresIndividuais[materia] ?? 0) + 1;
        totalAtual++;
        _controllerNumeroPerguntas.text = totalAtual.toString();
      }
    });
  }

  void _voltarPergunta() {
    setState(() {
      int totalAtual = int.tryParse(_controllerNumeroPerguntas.text) ?? 0;
      if (totalAtual > 0) {
        totalAtual--;
        _controllerNumeroPerguntas.text = totalAtual.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'NOTA 1000',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Grade dos 14 botões
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 15,
                    childAspectRatio: 14/5,
                  ),
                  itemCount: question.length,
                  itemBuilder: (context, index) {
                    final materia = question[index];
                    final contadorInd = contadoresIndividuais[materia] ?? 0;

                    return MateriaButton(
                      materia: materia,
                      contador: contadorInd,
                      onPressed: () => _incrementarMateria(materia),
                    );
                  },
                ),

                const SizedBox(height: 25),

                // Painel Inferior
                PainelInferior(
                  controller: _controllerNumeroPerguntas,
                  temTempo: temTempo,
                  onChangedTempo: (value) {
                    setState(() {
                      temTempo = value ?? false;
                    });
                  },
                  onPressedVoltar: _voltarPergunta,
                  onPressedComecar: () {
                    _iniciarQuiz();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MateriaButton extends StatelessWidget {
  final String materia;
  final int contador;
  final VoidCallback onPressed;

  const MateriaButton({
    super.key,
    required this.materia,
    required this.contador,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.black87,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              materia,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              '$contador',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class PainelInferior extends StatelessWidget {
  final TextEditingController controller;
  final bool temTempo;
  final ValueChanged<bool?> onChangedTempo;
  final VoidCallback onPressedVoltar;
  final VoidCallback onPressedComecar;

  const PainelInferior({
    super.key,
    required this.controller,
    required this.temTempo,
    required this.onChangedTempo,
    required this.onPressedVoltar,
    required this.onPressedComecar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Numero de Perguntas',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black54),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[300],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: temTempo,
                onChanged: onChangedTempo,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Tempo para as perguntas',
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ],
        ),
        const SizedBox(height: 25),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: onPressedVoltar,
                child: const Text(
                  'VOLTAR',
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00B050),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: onPressedComecar,
                child: const Text(
                  'INICIAR',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
